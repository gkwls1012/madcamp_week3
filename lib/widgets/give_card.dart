import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:untitled/screens/chat_room_screen.dart';
import 'package:untitled/models/chatroom.dart';

class GiveCard extends StatefulWidget {
  final item;

  const GiveCard(
      {Key? key,
      required this.item})
      : super(key: key);

  @override
  _GiveCardState createState() => _GiveCardState();
}

class _GiveCardState extends State<GiveCard> {

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.item['doneDate'].toDate();
    String dateString = DateFormat('yyyy-MM-dd').format(dateTime);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Image(image: AssetImage('assets/pin.png'), width:20),
                SizedBox(width:15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.item['postName'], style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(dateString, style: TextStyle(color: blueColor1),)
                  ],
                )
              ],
            )

          ],
        ),
      ),
    );
  }
}
