import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/user_provider.dart';
import 'package:untitled/utils/colors.dart';
import '../models/user.dart' as model;
import '../utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {

  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }


  /*String username = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
  }
  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      username = (snap.data() as Map<String, dynamic>)['username'];
    });
  }*/
  @override
  Widget build(BuildContext context) {
    //return Scaffold(body: Center(child:Text('$username'),));
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
            items: [
                BottomNavigationBarItem(
                icon: Icon(Icons.home, color: _page==0? Colors.black : primaryColor ,),
                label: '',
                ),
              BottomNavigationBarItem(
              icon: Icon(Icons.search, color: _page==1? Colors.black: primaryColor,),
              label: '',
              backgroundColor: primaryColor,
              ),
              BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, color: _page==2? Colors.black: primaryColor,),
              label: '',
              backgroundColor: primaryColor,
              ),
              BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble, color: _page==3? Colors.black: primaryColor,),
              label: '',
              backgroundColor: primaryColor,
              ),
              BottomNavigationBarItem(
              icon: Icon(Icons.person,color: _page==4? Colors.black: primaryColor,),
              label: '',
              backgroundColor: primaryColor,
              ),
              ],
          onTap: navigationTapped,

        ),
      ),
            );
          }
}
