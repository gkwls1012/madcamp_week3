import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/utils/colors.dart';

import '../widgets/recieve_card.dart';

class Recieve extends StatefulWidget {
  const Recieve({Key? key}) : super(key: key);

  @override
  _RecieveState createState() => _RecieveState();
}

class _RecieveState extends State<Recieve> {
  List<List<String>> give = [
    ["title1", "030303"],
    ["title2", "040404"],
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [secondaryColor, primaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
              itemCount: give.length,
              itemBuilder: (context, index) {
                return RecieveCard(
                  snap: give[index],
                );
              },
        ),
      ),
    );
  }
}
