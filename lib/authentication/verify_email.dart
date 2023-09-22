import 'dart:async';
import 'package:carpool/component/button.dart';
import 'package:carpool/screens/landing_page.dart';
import 'package:carpool/utility/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerification();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const LandingPage()
      : Scaffold(
          appBar: AppBar(
            title: const Text(
              'Verify Email',
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
            backgroundColor: Colors.blue[300],
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(12))),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text(
                'A verfication email has been sent to you.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 24,
              ),
              CustomButton(
                  buttonText: 'Resend Email', buttonClicked: sendVerification),
              // ElevatedButton.icon(
              //   style:
              //       ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
              //   icon: const Icon(
              //     Icons.lock_open,
              //     size: 32,
              //   ),
              //   label: const Text(
              //     'Resend Email',
              //     style: TextStyle(fontSize: 24),
              //   ),
              //   onPressed: sendVerification,
              // ),
              SizedBox(
                height: 8,
              ),
              CustomButton(
                  buttonText: 'Cancel',
                  buttonClicked: () => FirebaseAuth.instance.signOut()),
              // ElevatedButton(
              //   onPressed: () => FirebaseAuth.instance.signOut(),
              //   child: Text('Cancel'),
              //   style:
              //       ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
              // ),
            ],
          ),
        );
}
