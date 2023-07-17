import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/models/chatroom.dart';
import 'package:untitled/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatefulWidget {
  final ChatRoom chatRoom;
  const ChatRoomPage({required this.chatRoom, super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final _firestore = FirebaseFirestore.instance;
  final _chatController = TextEditingController();
  final _chatFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // getinfo();
  }

  // }

  createData(String content, String user) async {
    if (content.trim().isNotEmpty) {
      final messageCollectionReference = _firestore
          .collection('chatRooms')
          .doc(widget.chatRoom.id)
          .collection('messages')
          .doc();
      messageCollectionReference.set(
          {"content": content, "sender": user, "timestamp": DateTime.now()});
      _chatController.clear();
      // print(DateTime.now().add(const Duration(hours: 9)));
    }
  }

  @override
  void dispose() {
    _chatController.dispose();
    _chatFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<UserProvider>();
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
                    .doc(widget.chatRoom.id)
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
                        final isMe = messages[index]['sender'] == provider.getUser.uid;
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
                        createData(_chatController.text, provider.getUser.uid);
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
                      CupertinoActionSheetAction(
                          onPressed: () {
                            setState(() {});
                          },
                          child: Text(
                            "알림끄기",
                          )),
                      CupertinoActionSheetAction(
                          onPressed: () {
                            setState(() {});
                          },
                          child: Text(
                            "차단하기",
                          )),
                      CupertinoActionSheetAction(
                          onPressed: () {
                            setState(() {});
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
