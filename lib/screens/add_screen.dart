
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:untitled/resources/firestore_methods.dart';
import 'package:untitled/utils/colors.dart';
import 'package:untitled/utils/utils.dart';

class AddDialog extends StatefulWidget {
  const AddDialog({Key? key}) : super(key: key);

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  bool _isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  LocationData? _currentLocation;

  String uid = "";
  String username = "";
  double latitude = 0;
  double longitude = 0;

  @override
  void initState() {
    super.initState();
    getinfo();
    requestLocationPermission();
  }

  void getinfo() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      username = (snap.data() as Map<String, dynamic>)['username'];
      uid = (snap.data() as Map<String, dynamic>)['uid'];
    });
  }

  Future<void> requestLocationPermission() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check if location service is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // Location service is still not enabled
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        // Location permission is not granted
        return;
      }
    }

    // Location permission is granted, retrieve current location
    LocationData? locationData = await location.getLocation();
    if(this.mounted){
      setState(() {
        _currentLocation = locationData;
      });
    }
  }

  void postImage(
      String uid,
      String username,
      double? latitude,
      double? longitude,
      ) async {
    setState(() {
      _isLoading = true;
    });

    double postLatitude = latitude ?? 0; // Use 0 if latitude is null
    double postLongitude = longitude ?? 0; // Use 0 if longitude is null

    try {
      String res = await FirestoreMethods().uploadPost(
        _titleController.text,
        _descriptionController.text,
        uid,
        username,
        postLatitude,
        postLongitude,
      );

      if (res == "success") {
        showSnackBar('Posted!', context);
        Navigator.pop(context); // Dismiss the AddDialog
      } else {
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(// Set the background color to blue
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [blueColor2, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
          //border: Border.all(color: Colors.white, width: 2),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              username + ' 님! 새로운 도움을 요청해보세요',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "한줄소개",
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Add vertical padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Set rounded corners
                  borderSide: BorderSide.none, // Remove the border
                ),
              ),
              style: TextStyle(color: Colors.black, fontSize: 14),
              maxLines: 1,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: "내용을 입력해주세요",
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Add vertical padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Set rounded corners
                  borderSide: BorderSide.none, // Remove the border
                ),
              ),
              style: TextStyle(color: Colors.black, fontSize: 14),
              maxLines: 10,
            ),

            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => postImage(
                uid,
                username,
                _currentLocation!.latitude,
                _currentLocation!.longitude,
              ),
              style: ElevatedButton.styleFrom(
                primary: primaryColor, // Set the background color of the button
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                'Post',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            )

          ],
        ),
      ),
      ),
    );
  }
}