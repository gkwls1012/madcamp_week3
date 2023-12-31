import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/screens/recieve_list_screen.dart';
import 'package:untitled/utils/colors.dart';
import '../utils/utils.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "";
  String uid = "";
  String email = "";
  String bio = "";

  @override
  void initState() {
    super.initState();
    getinfo();
  }

  void getinfo() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      username = (snap.data() as Map<String, dynamic>)['username'];
      uid = (snap.data() as Map<String, dynamic>)['uid'];
      email = (snap.data() as Map<String, dynamic>)['email'];
      bio = (snap.data() as Map<String, dynamic>)['bio'];
    });
  }

  void logout() async {
    FirebaseAuth.instance.signOut();
    showSnackBar('로그아웃 되었습니다', context);
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void editProfile() {
    TextEditingController usernamecontroller =
        TextEditingController(text: username);
    TextEditingController emailcontroller = TextEditingController(text: email);
    TextEditingController biocontroller = TextEditingController(text: bio);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('프로필 편집'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add your form fields or input widgets here for editing user info
              TextField(
                decoration: InputDecoration(labelText: '닉네임'),
                controller: usernamecontroller,
              ),
              TextField(
                decoration: InputDecoration(labelText: '이메일 주소'),
                controller: emailcontroller,
              ),
              TextField(
                decoration: InputDecoration(labelText: '한 줄 소개'),
                controller: biocontroller,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                DocumentSnapshot snap = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .get();

                if (snap.exists) {
                  // User document exists, update the fields
                  Map<String, dynamic> userData =
                      snap.data() as Map<String, dynamic>;

                  // Update the desired fields
                  userData['email'] = emailcontroller.text;
                  userData['username'] = usernamecontroller.text;
                  userData['bio'] = biocontroller.text;

                  // Save the updated user document back to Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update(userData);
                  showSnackBar('프로필이 변경되었습니다', context);
                } else {
                  // User document doesn't exist, handle the error or create a new document
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> stringList = [
      'String 1',
      'String 2',
      'String 3',
      'String 4',
      'String 5'
    ];
    return Scaffold(
        body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [secondaryColor, primaryColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: 20),

                //username
                Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' 님',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),

                        //이메일주소
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '이메일 주소: $email',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        //한줄소개
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '한 줄 소개: $bio',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(top: 10, right: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white.withOpacity(0.8),
                              ),
                              child: TextButton(
                                onPressed: editProfile,
                                child: Text(
                                  ' 프로필편집 ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(top: 10, right: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white.withOpacity(0.8),
                              ),
                              child: TextButton(
                                onPressed: logout,
                                child: Text(
                                  ' 로그아웃 ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 10),
                Container(
                  width: 240,
                  child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(image: AssetImage('assets/tape.png')),
                          TextButton(onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Recieve()),
                            );
                          }, child: Text('내가 준 도움 기록')),
                        ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    ));
  }
}
