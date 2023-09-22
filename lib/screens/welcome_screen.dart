import 'package:carpool/authentication/verify_email.dart';
import 'package:carpool/component/button.dart';
import 'package:carpool/screens/home_page.dart';
import 'package:carpool/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import '../authentication/auth_page.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'UniGo Carpool',
          style: TextStyle(
            color: Colors.black87,
            // fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.blue[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
      ),
      body: Container(
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Text(
                '\nDEP Team: T11\n',
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                // style: GoogleFonts.ubuntu(
                //   color: Colors.black,
                //   fontWeight: FontWeight.bold,
                //   fontSize: 18,
                // ),
              ),
              // const SizedBox(
              //   height: 8,
              // ),
              const Text(
                'Eco-Safe Rides with Fraternity\nTravel together, save money!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Image.asset(
                "assets/carmoving.gif",
                // "assets/images/mainpage.jpg",
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              const SizedBox(
                height: 8,
              ),
              CustomButton(
                buttonText: 'Get Started',
                buttonClicked: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return const VerifyEmail();
                          } else {
                            return const AuthPage();
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
