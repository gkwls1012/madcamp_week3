import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/utils/colors.dart';
import 'package:untitled/models/chatroom.dart';
import 'package:untitled/screens/chat_room_screen.dart';
import 'package:untitled/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getinfo();
  }

  void getinfo() async {
    var provider = context.read<UserProvider>();
    setState(() {
      _isLoading = true;
    });
    await provider.refreshUser();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<UserProvider>();
    if(_isLoading){
      return SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [secondaryColor, primaryColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    return GestureDetector(
      child: CupertinoPageScaffold(
        // navigationBar: CupertinoNavigationBar(
        //   automaticallyImplyLeading: true,
        //   leading: Align(
        //     widthFactor: 1.0,
        //     alignment: Alignment.center,
        //     child: DefaultTextStyle(
        //       child: Text("채팅"),
        //       style: TextStyle(color: Colors.black, fontSize: 15),
        //     ),
        //   ),
        // ),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [secondaryColor, primaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chatRooms')
                      .where('participants', arrayContains: provider.getUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    final rooms = snapshot.data!.docs;
                    return Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(right: 16.0),
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          final String id = rooms[index].id;
                          final String name = rooms[index]['name'];
                          var lastMessage;

                          // Messages 컬렉션을 가져오기 위해 서브컬렉션 참조
                          CollectionReference messagesRef =
                              rooms[index].reference.collection('messages');

                          return StreamBuilder<QuerySnapshot>(
                            stream: messagesRef
                                .orderBy('timestamp', descending: true)
                                .limit(1)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              final messages = snapshot.data!.docs;
                              if (messages.isNotEmpty) {
                                // messages 컬렉션에서 가장 최근 메시지 가져오기
                                lastMessage = messages[0];
                              }

                              return CupertinoListTile(
                                padding: EdgeInsets.zero,
                                leadingToTitle: 0,
                                leadingSize: 80,
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  color: Colors.black,
                                ),
                                title: Text(name),
                                subtitle: Text(lastMessage['content']),
                                additionalInfo: Text(
                                  '${(lastMessage['timestamp'].toDate().hour + 9).toString().padLeft(2, '0')}:${lastMessage['timestamp'].toDate().minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatRoomPage(
                                        chatRoom: ChatRoom(id: id, name: name),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
