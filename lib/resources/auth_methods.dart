import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/resources/storage_methods.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    //required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try{
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty && bio.isNotEmpty) {

        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        //print(cred.user!.uid);
        //String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);
        
        //add user to our database
        _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          //'photoUrl': photoUrl,
        });
        res = "success";
      }
    } on FirebaseAuthException catch(err){
      if(err.code == 'invalid-email'){
        res = 'The email format is wrong.';
      } else if(err.code == 'weak-password'){
        res = 'Password should be at least 6 characters';
      }
    }

    catch(err){
      res = err.toString();
    }
    return res;
  }

  //logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    }
    // on FirebaseAuthException catch (e){
    //   if(e.code == 'wrong-password'){
    //
    //   }
    // }
    catch (err) {
      res = err.toString();
    }

    return res; // Return the result at the end of the method
  }

}