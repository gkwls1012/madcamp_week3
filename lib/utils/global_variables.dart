import 'package:flutter/material.dart';
import 'package:untitled/screens/chat_screen.dart';
import 'package:untitled/screens/feed_screen.dart';
import '../screens/add_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/test_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
    MyApp(),
    FeedScreen(),
    Text(''),
    ChatScreen(),
    ProfileScreen(),
  ];
