
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/utils/colors.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Center(
                    child: Text('Profile')
        /*GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude, longitude), // Set the initial center of the map
                        zoom: 15.0, // Set the initial zoom level
                      ),
                      markers: Set<Marker>.from([
                        Marker(
                          markerId: MarkerId('post1'), // Unique ID for the marker
                          position: LatLng(postLatitude, postLongitude), // Coordinates of the post location
                          infoWindow: InfoWindow(title: 'Post 1'), // Info window content for the marker
                        ),
                        // Add more markers for other post locations
                      ]),
                    )
*/
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
