import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/resources/storage_methods.dart';
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
      ) async {
    String res = "some error occurred";
    try {
      //String photoUrl =
      //await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        title: title,
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        likes: [],
      );

      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res; // Add the return statement here
  }
}
