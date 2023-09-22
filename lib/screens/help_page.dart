import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.blue[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
      ),
      body: Center(
        child: ListView(
          children: const [
            SizedBox(
              height: 8,
            ),
            ListTile(
              leading: Icon(Icons.numbers),
              title: Text(
                'You can offer your ride that you wish to offer via offer button on home page.',
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.numbers),
              title: Text(
                'You can join by requesting rides offered by other users via join button on home page.',
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.numbers),
              title: Text(
                'You can view your rides on my rides page. In your offered rides you can accept or reject requests by other users and also cancel rides. In you joined rides, you can leave the ride. In both of them, you can contact other fellow passengers by clicking on the card.',
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.numbers),
              title: Text(
                'You can view status of your requests on the requests page.',
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.numbers),
              title: Text(
                'You can change your password and contact, and also logout via profile options in account page.',
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.numbers),
              title: Text(
                'In case of any query or suggestions to make the app better, make sure to contact us through the about us page.',
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
