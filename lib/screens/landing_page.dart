import 'package:carpool/screens/about_us.dart';
import 'package:carpool/screens/account_page.dart';
import 'package:carpool/screens/help_page.dart';
import 'package:carpool/screens/home_page.dart';
import 'package:carpool/screens/my_rides_page.dart';
import 'package:carpool/screens/my_requests_page.dart';
// import 'package:carpool/screens/requests_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var user = FirebaseAuth.instance.currentUser!;

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;

  final tabs = [
    HomePage(),
    MyRidesPage(),
    RequestsPage(),
    AccountPage(),
    AboutUs(),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      user = FirebaseAuth.instance.currentUser!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '  UniGo',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        actions: [
          SizedBox(
            width: 4,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpPage(),
                ),
              );
            },
            icon: Icon(
              Icons.question_mark,
              color: Colors.black,
            ),
          ),
        ],
        backgroundColor: Colors.blue[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Colors.blue[300],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            activeIcon: Icon(Icons.home, color: Colors.black87),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car, color: Colors.white),
            activeIcon: Icon(Icons.directions_car, color: Colors.black87),
            label: 'My Rides',
          ),
          BottomNavigationBarItem(
            // Icons.taxi_alert
            icon: Icon(Icons.add_alert, color: Colors.white),
            activeIcon: Icon(Icons.add_alert, color: Colors.black87),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            activeIcon: Icon(Icons.person, color: Colors.black87),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, color: Colors.white),
            activeIcon: Icon(Icons.person, color: Colors.black87),
            label: 'About Us',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
