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
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final documents = snapshot.data!.docs;
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(36.3721, 127.3604),
                  zoom: 15.0,
                ),
                markers: Set<Marker>.from(
                  documents.map((snap) {
                    final latitude = snap['latitude'];
                    final longitude = snap['longitude'];

                    return Marker(
                      markerId: MarkerId(snap.id),
                      position: LatLng(latitude, longitude),
                      infoWindow: InfoWindow(title: snap['title']),
                    );
                  }),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )



      ),
    );
  }
}
