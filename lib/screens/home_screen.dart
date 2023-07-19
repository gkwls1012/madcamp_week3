import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  String username = "";
  List give = [];
  List receive = [];
  List giving = [];
  List receiving = [];


  @override
  void initState() {
    super.initState();
    getinfo();
    fetchDocuments();
  }

  void getinfo() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if(this.mounted){
      setState(() {
        username = (snap.data() as Map<String, dynamic>)['username'];
        give = (snap.data() as Map<String, dynamic>)['give'];
        receive = (snap.data() as Map<String, dynamic>)['receive'];
        giving = (snap.data() as Map<String, dynamic>)['giving'];
        receiving = (snap.data() as Map<String, dynamic>)['receiving'];
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<List<Marker>> fetchDocuments() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('posts');
    List<Marker> markers = [];

    try {
      QuerySnapshot querySnapshot = await collectionRef.get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        // Access document data
        final Map<String, dynamic> data =
            docSnapshot.data() as Map<String, dynamic>;
        String title = data['title'];
        String postId = data['postId'];
        double latitude = data['latitude'];
        double longitude = data['longitude'];

        markers.add(
          Marker(
            markerId: MarkerId(postId),
            // Unique ID for the marker
            position: LatLng(latitude, longitude),
            // Coordinates of the post location
            infoWindow:
                InfoWindow(title: title), // Info window content for the marker
          ),
        );
      }
    } catch (e) {
      print('Error fetching documents: $e');
    }

    return markers;
  }

  void showInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300, // Set the desired width
            height: 310, // Set the desired height
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height:10, ),

                Image.asset('assets/info.png'),
                // Replace 'assets/image.png' with the path to your image

                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '닫기',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [secondaryColor, primaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image(
                      image: AssetImage('assets/wavinghand.png'),
                      width: 50,
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' 님,',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '도움을 주고 받아 보세요',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 15),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 내가 준 도움
                    Container(
                      width: 135,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      padding: EdgeInsets.only(bottom: 10, top: 10),
                      margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '내가 준 도움',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          (give.length<10)?Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 12,
                                  ),
                                  Text(
                                    give.length.toString()+' / Lv.1',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Expanded(
                                  child: Image.asset(
                                    'assets/toll.gif',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          )
                              :Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 12,
                                  ),
                                  Text(
                                    give.length.toString()+' / Lv.2',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Expanded(
                                  child: Image.asset(
                                    'assets/baeby.gif',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // 내가 받은 도움
                    Container(
                      width: 135,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      padding: EdgeInsets.only(bottom: 10, top: 10),
                      margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '내가 받은 도움',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          (receive.length<10)?Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 12,
                                  ),
                                  Text(
                                    receive.length.toString()+' / Lv.1',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Expanded(
                                  child: Image.asset(
                                    'assets/toll.gif',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          )
                              :Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 12,
                                  ),
                                  Text(
                                    receive.length.toString()+' / Lv.2',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Expanded(
                                  child: Image.asset(
                                    'assets/baeby.gif',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: showInfo,
                      icon: Icon(Icons.info, color: Colors.white),
                    )
                  ],
                ),
                Divider(),
                SizedBox(height: 10),
                //진행 중인 도움
                Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Image(
                              image: AssetImage('assets/check.jpg'),
                              width: 30,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Text(
                                '진행 중인 도움',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      (giving.length==0)? Text('없음'):Expanded(child:Container(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: giving.length,
                          itemBuilder: (context, index) {
                            final item = giving[index]['postName'];
                            return Container(
                              margin: EdgeInsets.all(8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(horizontal:8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Center(child:Text(
                                    item,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),)
                                ),
                              ),

                            );
                          },
                        ),
                      ),),

                    ],
                  ),
                SizedBox(height: 5),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Image(
                              image: AssetImage('assets/megaphone.jpg'),
                              width: 30,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Text(
                                '요청 중인 도움',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      (receiving.length==0)? Text('없음'): Expanded(child:Container(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: receiving.length,
                          itemBuilder: (context, index) {
                            final item = receiving[index]['postName'];
                            return Container(
                              margin: EdgeInsets.all(8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(horizontal:8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Center(child:Text(
                                    item,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  )),
                                ),
                              ),

                            );
                          },
                        ),
                      ),),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Divider(),

                SizedBox(height: 10),
                //Map
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: Colors.white,
                            ));
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
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
              ],
            ),
          ),
        ));
  }
}
