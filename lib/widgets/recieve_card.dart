import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:untitled/screens/chat_room_screen.dart';
import 'package:untitled/models/chatroom.dart';

class RecieveCard extends StatefulWidget {
  final snap;

  const RecieveCard(
      {Key? key,
      required this.snap,})
      : super(key: key);

  @override
  _RecieveCardState createState() => _RecieveCardState();
}

class _RecieveCardState extends State<RecieveCard> {

  @override
  Widget build(BuildContext context) {
    String title = widget.snap[0];
    String date = widget.snap[1];

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Image(image: AssetImage('assets/pin.png'))
        ],
      ),
    );
  }
}
