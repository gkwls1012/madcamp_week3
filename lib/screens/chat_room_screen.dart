import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/models/chatroom.dart';
import 'package:untitled/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatefulWidget {
  final ChatRoom chatRoom;
  final dynamic snap;
  final String helpUid;
  const ChatRoomPage({required this.chatRoom, this.snap, required this.helpUid, super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final _firestore = FirebaseFirestore.instance;
  final _chatController = TextEditingController();
  final _chatFocusNode = FocusNode();

  bool _isRoomCreated = false;
  bool _isRoomRemoved = false;
  var user;

  @override
  void initState() {
    super.initState();
    if (widget.chatRoom.id != null) {
      setState(() {
        _isRoomCreated = true;
      });
    }
    // getinfo();
  }

  // }

  createData(String content, String user) async {
    if (content.trim().isNotEmpty) {
      _chatController.clear();
      final messageCollectionReference = _firestore
          .collection('chatRooms')
          .doc(((widget.chatRoom.id == null) && _isRoomCreated)
              ? widget.snap['postId']
              : widget.chatRoom.id)
          .collection('messages')
          .doc();
      await messageCollectionReference.set(
          {"content": content, "sender": user, "timestamp": DateTime.now()});
      // print(DateTime.now().add(const Duration(hours: 9)));
    }
  }

  createChatRoom(String content, String user) async {
    if (content.trim().isNotEmpty) {
      _chatController.clear();
      // 상위 컬렉션 참조
      final chatRoomsRef =
          _firestore.collection('chatRooms').doc(widget.snap['postId']);

      await chatRoomsRef.get().then((docSnapshot) async {
        if (docSnapshot.exists) {
          // 문서가 존재하는 경우
          print('문서가 존재합니다.');
        } else {
          // 문서가 존재하지 않는 경우
          print('문서가 존재하지 않습니다.');
          // 상위 컬렉션에 새로운 문서 추가
          await chatRoomsRef.set({
            "name": widget.chatRoom.name,
            "participants": [widget.snap["uid"], user],
          });

          // 하위 컬렉션 참조
          CollectionReference messagesRef = chatRoomsRef.collection('messages');

          // 하위 컬렉션에 새로운 문서 추가
          await messagesRef.add({
            'content': content,
            'sender': user,
            'timestamp': DateTime.now(),
          });

          await _firestore
              .collection('posts')
              .doc(widget.snap['postId'])
              .update({
            "likes": [user]
          });

          await _firestore.collection('users').doc(user).update({
            "giving": FieldValue.arrayUnion([
              {
                "postId": widget.snap['postId'] ?? widget.chatRoom.id,
                "postName": widget.chatRoom.name
              }
            ])
          });

          await _firestore.collection('users').doc(widget.snap["uid"]).update({
            "receiving": FieldValue.arrayUnion([
              {
                "postId": widget.snap['postId'] ?? widget.chatRoom.id,
                "postName": widget.chatRoom.name
              }
            ])
          });

          setState(() {
            _isRoomCreated = true;
          });
        }
      });
    }
  }

  removeChatRoom() async {
    if (_isRoomCreated) {
      await _firestore
          .collection('chatRooms')
          .doc(((widget.chatRoom.id == null) && _isRoomCreated)
              ? widget.snap['postId']
              : widget.chatRoom.id)
          .delete();
      // 해당 문서에 포함된 모든 컬렉션 가져오기
      QuerySnapshot collectionSnapshot = await _firestore
          .collection('chatRooms')
          .doc(((widget.chatRoom.id == null) && _isRoomCreated)
              ? widget.snap['postId']
              : widget.chatRoom.id)
          .collection('messages')
          .get();

      // 각 컬렉션의 문서를 하나씩 삭제
      collectionSnapshot.docs.forEach((doc) async {
        await doc.reference.delete();
      });
      await _firestore
          .collection('posts')
          .doc(((widget.chatRoom.id == null) && _isRoomCreated)
              ? widget.snap['postId']
              : widget.chatRoom.id)
          .update({"likes": []});
      await _firestore.collection('users').doc(widget.helpUid).update({
        "giving": FieldValue.arrayRemove([
          {
            "postId": widget.chatRoom.id ?? widget.snap['postId'],
            "postName": widget.chatRoom.name
          }
        ])
      });

      await _firestore.collection('users').doc(widget.snap["uid"]).update({
        "receiving": FieldValue.arrayRemove([
          {
            "postId": widget.chatRoom.id ?? widget.snap['postId'],
            "postName": widget.chatRoom.name
          }
        ])
      });
      setState(() {
        _isRoomRemoved = true;
      });
    }
  }

  doneRequest(DateTime doneDate) async {
    await _firestore.collection('users').doc(widget.helpUid).update({
      "give": FieldValue.arrayUnion([
        {
          "postName": widget.chatRoom.name,
          "doneDate": doneDate
        }
      ])
    });

    await _firestore.collection('users').doc(widget.snap["uid"]).update({
      "receive": FieldValue.arrayUnion([
        {
          "postName": widget.chatRoom.name,
          "doneDate": doneDate
        }
      ])
    });

    await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.chatRoom.id)
            .delete();
  }

  @override
  void dispose() {
    _chatController.dispose();
    _chatFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.snap);
    var provider = context.watch<UserProvider>();
    user = provider.getUser.uid;
    // if(_isLoading){
    //   return SafeArea(
    //     child: Container(
    //       // decoration: BoxDecoration(
    //       //   gradient: LinearGradient(
    //       //     colors: [secondaryColor, primaryColor],
    //       //     begin: Alignment.topCenter,
    //       //     end: Alignment.bottomCenter,
    //       //   ),
    //       // ),
    //       child: Center(child: CircularProgressIndicator(
    //           color: Colors.white,
    //         ),
    //       ),
    //     ),
    //   );
    // }
    return GestureDetector(
      onTap: () {
        // FocusScope.of(context).unfocus();
        _chatFocusNode.unfocus();
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(widget.chatRoom.name),
          trailing: CupertinoButton(
            onPressed: () {
              _showCategory(context);
            },
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.ellipsis_vertical),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatRooms')
                    .doc(((widget.chatRoom.id == null) && _isRoomCreated)
                        ? widget.snap['postId']
                        : widget.chatRoom.id)
                    .collection('messages')
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final messages = snapshot.data!.docs;
                  return Expanded(
                    child: ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.all(16.0),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index]['content'];
                        final isMe =
                            messages[index]['sender'] == provider.getUser.uid;
                        final dateTime = messages[index]['timestamp']
                            .toDate()
                            .add(const Duration(hours: 9));
                        final time =
                            '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
                        return ChatBubble(
                            isMe: isMe, message: message, time: time);
                      },
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: _chatController,
                        focusNode: _chatFocusNode,
                        placeholder: 'Type a message',
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: CupertinoColors.lightBackgroundGray,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    CupertinoButton(
                      child: Icon(Icons.send),
                      onPressed: () {
                        _isRoomCreated
                            ? createData(
                                _chatController.text, provider.getUser.uid)
                            : createChatRoom(
                                _chatController.text, provider.getUser.uid);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategory(BuildContext ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => StatefulBuilder(
              builder: ((context, setCategoryState) => CupertinoActionSheet(
                    actions: [
                      // CupertinoActionSheetAction(
                      //     onPressed: () {
                      //       setState(() {});
                      //     },
                      //     child: Text(
                      //       "알림끄기",
                      //     )),
                      // CupertinoActionSheetAction(
                      //     onPressed: () {
                      //       setState(() {});
                      //     },
                      //     child: Text(
                      //       "차단하기",
                      //     )),
                      if (widget.snap["uid"] == user)
                        CupertinoActionSheetAction(
                            onPressed: () async {
                              final DateTime doneDate = DateTime.now();
                              await removeChatRoom();
                              await doneRequest(doneDate);
                              Navigator.pop(context);
                            },
                            child: Text(
                              "완료하기",
                            )),
                      CupertinoActionSheetAction(
                          onPressed: () async {
                            await removeChatRoom();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "채팅방 나가기",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () => _close(_),
                      child: const Text('취소'),
                    ),
                  )),
            ));
  }

  void _close(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }
}

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final String time;

  ChatBubble({required this.isMe, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 4.0),
        child: DefaultTextStyle(
          child: Text(message),
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
