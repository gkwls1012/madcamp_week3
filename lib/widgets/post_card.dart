import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/utils/colors.dart';
import 'package:intl/intl.dart';


class PostCard extends StatelessWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = snap['datePublished'];
    DateTime dateTime = timestamp.toDate();
    String dateString = DateFormat('yyyy-MM-dd').format(dateTime);
    var date = dateString;
    return Card(
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ).copyWith(right: 0),
              child: Row(
                children: [
                  Image(
                    image: AssetImage('assets/wavinghand.png'),
                    width: 25,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                              Text(
                      snap['title'],
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), // Set the border radius for rounded corners
                      color: blueColor2,
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text('도와주기', style: TextStyle(color: Colors.white,),),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            //Description and number of comments
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: snap['description'],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      snap['username']+'이  '+date+'에 요청한 도움',
                      style: const TextStyle(fontSize: 14, color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
