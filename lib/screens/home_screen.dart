import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import '../utils/colors.dart';

void main() => runApp(const HomeScreen());

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Marker> markerList = [];
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(37.5665, 126.9780);

  @override
  void initState() {
    super.initState();
    fetchDocuments();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

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
    return MaterialApp(
      home: Scaffold(
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
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '내 주변의 도움 요청들',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    margin: EdgeInsets.only(top: 0),
                    child: FutureBuilder<List<Marker>>(
                      future: fetchDocuments(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(
                            color: Colors.white,
                          ));
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          List<Marker> markerList = snapshot.data!;
                          return GoogleMap(
                            onMapCreated: _onMapCreated,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
