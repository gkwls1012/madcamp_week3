import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Marker> markerList = [];

  Future<List<Marker>> fetchDocuments() async {
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('posts');
    List<Marker> markers = [];

    try {
      QuerySnapshot querySnapshot = await collectionRef.get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        // Access document data
        final Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        String title = data['title'];
        String postId = data['postId'];
        double latitude = data['latitude'];
        double longitude = data['longitude'];

        markers.add(
          Marker(
            markerId: MarkerId(postId), // Unique ID for the marker
            position: LatLng(latitude, longitude), // Coordinates of the post location
            infoWindow: InfoWindow(title: title), // Info window content for the marker
          ),
        );

        print('title: $title');
        print('latitude: $latitude');
        print('longitude: $longitude');
      }
    } catch (e) {
      print('Error fetching documents: $e');
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Row(
          children: [
            Image(
              image: AssetImage('assets/logo_helphand.png'),
              height: 40,
              color: primaryColor,
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [secondaryColor, primaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Marker>>(
          future: fetchDocuments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              markerList = snapshot.data!;
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(36.3721, 127.3604),
                  zoom: 15.0,
                ),
                markers: Set<Marker>.from(markerList),
              );
            } else {
              return Container(); // Empty container as a fallback
            }
          },
        ),
      ),
    );
  }
}

