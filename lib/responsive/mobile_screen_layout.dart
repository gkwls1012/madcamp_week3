import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/user_provider.dart';
import 'package:untitled/utils/colors.dart';
import '../models/user.dart' as model;
import '../screens/add_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    //return Scaffold(body: Center(child:Text('$username'),));
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: primaryColor,
        items: <Widget>[
        Icon(Icons.home, size: 20),
        Icon(Icons.list, size: 20),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AddDialog(),
              );
            },
            icon: Icon(
              Icons.add_circle,
              size: 20,
              color: Colors.blue,
            ),
          ),
        Icon(Icons.chat, size: 20),
        Icon(Icons.person, size: 20),
        ],
        onTap: (index) {
          if (index == 2) {
            showDialog(
              context: context,
              builder: (_) => AddDialog(), // Show the AddDialog
            );
        }else{
            navigationTapped(index);
          }
        })

            );
          }
}
