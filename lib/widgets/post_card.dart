import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/utils/colors.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';


class PostCard extends StatefulWidget {
  final snap;
  final String uid;

  const PostCard({Key? key, required this.snap, required this.uid}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLoading = false;

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
        await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).delete();
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

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = widget.snap['datePublished'];
    DateTime dateTime = timestamp.toDate();
    String dateString = DateFormat('yyyy-MM-dd').format(dateTime);
    var date = dateString;
    bool mine = (widget.snap['uid'] == widget.uid);

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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['title'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (mine)
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.red,
                      ),
                      child: TextButton(
                        onPressed: () => _deletePost(context),
                        child: _isLoading
                            ? Center(child: CircularProgressIndicator(color: Colors.white))
                            : Text(
                          '삭제하기',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  else
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: blueColor2,
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          '도와주기',
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
                        style: TextStyle(color: Colors.black), // Set the text color to black
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
                      widget.snap['username'] + ' 님이  ' + date + '에 요청한 도움',
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

