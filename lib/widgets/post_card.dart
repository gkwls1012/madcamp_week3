import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:untitled/screens/chat_room_screen.dart';
import 'package:untitled/models/chatroom.dart';

class PostCard extends StatefulWidget {
  final snap;
  final String uid;
  final double latitude;
  final double longitude;

  const PostCard(
      {Key? key,
      required this.snap,
      required this.uid,
      required this.latitude,
      required this.longitude})
      : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLoading = false;
  String username = "";

  @override
  void initState() {
    getinfo(widget.snap['uid']);
    super.initState();
  }

  void getinfo(uid) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    print(snap.data());
    if (snap.exists) {
      if (this.mounted) {
        setState(() {
          username = (snap.data() as Map<String, dynamic>)['username'];
        });
      }
    } else {
      // 문서가 존재하지 않는 경우 처리
    }
  }

  void _deletePost(BuildContext context) async {
    // Show confirmation dialog
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('확인'),
          content: Text('정말로 이 게시물을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel deletion
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm deletion
              },
              child: Text('삭제'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .delete();
        // Post deleted successfully
      } catch (e) {
        // Error occurred while deleting the post
        print('Error deleting post: $e');
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _donePost(BuildContext context) async {
    final DateTime doneDate = DateTime.now();
    var _firestore = FirebaseFirestore.instance;
    // Show confirmation dialog
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('확인'),
          content: Text('정말로 이 요청을 완료하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel deletion
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm deletion
              },
              child: Text('완료'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        // 대상 문서의 참조를 가져오는 코드
        DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
            .collection("chatRooms")
            .doc(widget.snap['postId'])
            .get();

        // 문서의 데이터에서 필드 값을 추출하는 코드
        String helpUid = snapshot.data()?["participants"][1];

        // 채팅방 삭제
        await _firestore
            .collection('chatRooms')
            .doc(widget.snap['postId'])
            .delete();
        // 해당 문서에 포함된 모든 컬렉션 가져오기
        QuerySnapshot collectionSnapshot = await _firestore
            .collection('chatRooms')
            .doc(widget.snap['postId'])
            .collection('messages')
            .get();

        // 각 컬렉션의 문서를 하나씩 삭제
        collectionSnapshot.docs.forEach((doc) async {
          await doc.reference.delete();
        });

        await _firestore
            .collection('posts')
            .doc(widget.snap['postId'])
            .update({"likes": []});

        await _firestore.collection('users').doc(helpUid).update({
          "giving": FieldValue.arrayRemove([
            {
              "postId": widget.snap['postId'],
              "postName": widget.snap['title']
            }
          ])
        });

        await _firestore.collection('users').doc(widget.snap["uid"]).update({
          "receiving": FieldValue.arrayRemove([
            {
              "postId": widget.snap['postId'],
              "postName": widget.snap['title']
            }
          ])
        });

        await _firestore.collection('users').doc(helpUid).update({
          "give": FieldValue.arrayUnion([
            {
              "postName": widget.snap['title'],
              "doneDate": doneDate
            }
          ])
        });

        await _firestore.collection('users').doc(widget.snap["uid"]).update({
          "receive": FieldValue.arrayUnion([
            {
              "postName": widget.snap['title'],
              "doneDate": doneDate
            }
          ])
        });

        await FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.snap['postId'])
                .delete();
            // Post deleted successfully
      } catch (e) {
        // Error occurred while deleting the post
        print('Error done post: $e');
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int earthRadius = 6371; // in kilometers

    // Convert latitude and longitude from degrees to radians
    double lat1Rad = degreesToRadians(lat1);
    double lon1Rad = degreesToRadians(lon1);
    double lat2Rad = degreesToRadians(lat2);
    double lon2Rad = degreesToRadians(lon2);

    // Calculate the differences between the latitudes and longitudes
    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;

    // Apply the Haversine formula
    double a = pow(sin(dLat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Calculate the distance
    double distance = earthRadius * c;
    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = widget.snap['datePublished'];
    DateTime dateTime = timestamp.toDate();
    String dateString = DateFormat('yyyy-MM-dd').format(dateTime);
    var date = dateString;
    bool mine = (widget.snap['uid'] == widget.uid);
    double dist = calculateDistance(widget.snap['latitude'],
        widget.snap['longitude'], widget.latitude, widget.longitude);

    return Card(
      color: Colors.white.withOpacity(0.85),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ).copyWith(right: 0),
              child: Row(
                children: [
                  Image(
                    image: AssetImage('assets/wavinghand.png'),
                    width: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['title'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: (dist < 1)
                          ? Text((dist * 1000).toStringAsFixed(2) + 'm',
                              style: TextStyle(color: Colors.orange))
                          : Text(dist.toStringAsFixed(2) + 'km',
                              style: TextStyle(color: Colors.orangeAccent))),
                  if (mine)
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: widget.snap['likes'].isEmpty
                            ? Colors.red
                            : Colors.lightGreen,
                      ),
                      child: TextButton(
                        onPressed: () => widget.snap['likes'].isEmpty ? _deletePost(context) : _donePost(context),
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white))
                            : Text(
                                widget.snap['likes'].isEmpty ? '삭제하기' : '완료하기',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    )
                  else
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: widget.snap['likes'].isEmpty
                            ? blueColor2
                            : primaryColor,
                      ),
                      child: TextButton(
                        onPressed: () {
                          widget.snap['likes'].isEmpty
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatRoomPage(
                                      chatRoom: ChatRoom(
                                          id: null, name: widget.snap['title']),
                                      snap: widget.snap,
                                      helpUid: widget.uid,
                                    ),
                                  ),
                                )
                              : null;
                        },
                        child: Text(
                          widget.snap['likes'].isEmpty ? '도와주기' : '도움중',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: Colors.black), // Set the text color to black
                        children: [
                          TextSpan(
                            text: widget.snap['description'],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      username + ' 님이  ' + date + '에 요청한 도움',
                      style: const TextStyle(fontSize: 14, color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
