import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String username;
  final String bio;
  final List give;
  final List receive;
  final List giving;
  final List receiving;

  const User({
    required this.email,
    required this.uid,
    required this.username,
    required this.bio,
    required this.give,
    required this.receive,
    required this.giving,
    required this.receiving
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "email": email,
    "bio": bio,
    "give": give,
    "receive": receive,
    "giving": giving,
    "receiving": receiving,
    "giving": giving,
    "receiving": receiving,
  };

  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      bio: snapshot['bio'], //한줄소개
      give: snapshot['give'],
      receive: snapshot['receive'],
      giving: snapshot['giving'],
      receiving: snapshot['receiving'],
    );
  }
}
