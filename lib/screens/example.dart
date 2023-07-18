
import 'package:flutter/material.dart';
class ExampleScreen extends StatefulWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  bool isContainerExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isContainerExpanded = !isContainerExpanded;
              });
            },
            child: Container(
              width: isContainerExpanded ? 200 : 150,
              height: 150,
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Container 1',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isContainerExpanded = !isContainerExpanded;
              });
            },
            child: Container(
              width: isContainerExpanded ? 200 : 150,
              height: 150,
              color: Colors.green,
              child: Center(
                child: Text(
                  'Container 2',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isContainerExpanded,
            child: Column(
              children: [
                Text('Item 1'),
                Text('Item 2'),
                Text('Item 3'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
