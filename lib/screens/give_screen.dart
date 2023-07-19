import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:untitled/utils/colors.dart';
import 'package:untitled/widgets/post_card.dart';

import '../widgets/give_card.dart';

class GiveScreen extends StatefulWidget {
  final give;
  final state;
  const GiveScreen({Key? key,required this.give, required this.state}) : super(key: key);

  @override
  _GiveScreenState createState() => _GiveScreenState();
}

class _GiveScreenState extends State<GiveScreen> {

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('내가 '+widget.state+' 도움 목록'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/paper.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: widget.give.length ==0?
    Center(child: Text('아직 완료된 도움이 없습니다'))
    : ListView.builder(
              itemCount: widget.give.length,
              itemBuilder: (context, index) {
                return GiveCard(
                        item: widget.give[index],
                      );
              },)
        ),
    );
  }
}
