import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String title;
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final double latitude;
  final double longitude;
  final likes;

  const Post({
    required this.title,
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.likes,
    required this.latitude,
    required this.longitude,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "username": username,
    "uid": uid,
    "description": description,
    "postId": postId,
    "likes": likes,
    "datePublished": datePublished,
    "latitude": latitude,
    "longitude": longitude,
  };

  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      title: snapshot['title'],
      username: snapshot['username'],
      uid: snapshot['uid'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      likes: snapshot['likes'],
      datePublished: snapshot['datePublished'],
      latitude: snapshot['latitude'],
      longitude: snapshot['longitude'],
    );
  }
}
