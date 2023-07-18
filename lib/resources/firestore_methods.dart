
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
      String title,
      String description,
      String uid,
      String username,
      double latitude,
      double longitude,
      ) async {
    String res = "some error occurred";
    try {
      if(title.isNotEmpty && description.isNotEmpty) {
        String postId = const Uuid().v1();
        Post post = Post(
          title: title,
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          likes: [],
          latitude: latitude,
          longitude: longitude,
        );

        await _firestore.collection('posts').doc(postId).set(post.toJson());
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res; // Add the return statement here
  }
}
