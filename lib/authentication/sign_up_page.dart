import 'package:carpool/component/button.dart';
import 'package:carpool/component/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utility/utils.dart';

const List<String> list1 = <String>['Male', 'Female', 'Other'];
const List<String> list2 = <String>[
  'CSE',
  'EE',
  'MNC',
  'BM',
  'PHY',
  'CIV',
  'CHEM',
  'META',
  'ME',
  'Staff'
];
const List<String> list3 = <String>['Student', 'Faculty', 'Staff'];

class SignUpPage extends StatefulWidget {
  final Function() onClickedSignIn;
  const SignUpPage({super.key, required this.onClickedSignIn});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final namecontroller = TextEditingController();
  final entrycontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  String gender = 'Male';
  String dept = 'CSE';
  String type = 'Student';

  bool _loading = false;

  @override
  void initState() {
    _loading = false;
    super.initState();
  }

  @override
  void dispose() {
    namecontroller.dispose();
    entrycontroller.dispose();
    emailcontroller.dispose();
    phonecontroller.dispose();
    passwordcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.blue[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              TextFormField(
                controller: namecontroller,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (name) => name!.isEmpty
                    ? 'Enter name'
                    : (RegExp(r"^[a-zA-Z\\s]*$").hasMatch(name))
                        ? null
                        : 'Enter valid name',
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: entrycontroller,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Entry Number/Employee ID',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => (value!.isEmpty)
                    ? 'Enter Entry Number or Employee ID'
                    : (RegExp(r'^[0-9]+$').hasMatch(value))
                        ? null
                        : ((RegExp(r'[2-9][0-9]{3}[a-zA-Z]{3}[0-9]{4}')
                                .hasMatch(value))
                            ? null
                            : 'Enter valid Entry Number or Employee ID'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailcontroller,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) => (email != null &&
                            !EmailValidator.validate(email)) ||
                        !RegExp(r'[a-zA-Z0-9]+@iitrpr\.ac\.in').hasMatch(email!)
                    ? 'Enter a valid institute email'
                    : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: phonecontroller,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (phone) =>
                    (phone != null && !RegExp(r'[0-9]{10}').hasMatch(phone))
                        ? 'Enter a valid phone number'
                        : null,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                      items:
                          list3.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: type,
                      onChanged: (String? value) {
                        setState(() {
                          type = value!;
                        });
                      }),
                  const SizedBox(width: 48),
                  DropdownButton<String>(
                      items:
                          list2.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: dept,
                      onChanged: (String? value) {
                        setState(() {
                          dept = value!;
                        });
                      }),
                  const SizedBox(width: 48),
                  DropdownButton<String>(
                      // RADIO BUTTON
                      items:
                          list1.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: gender,
                      onChanged: (String? value) {
                        setState(() {
                          gender = value!;
                        });
                      }),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwordcontroller,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) => val != null && val.length < 8
                    ? 'Enter min. 8 characters'
                    : null,
              ),
              const SizedBox(height: 4),
              TextButton(
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  child: const Text(
                    'View Terms and Conditions',
                    style: TextStyle(fontSize: 16),
                  )),
              Text(
                'By signing up, you agree to our Terms and Conditions',
                style: TextStyle(
                  fontSize: 14,
                  // decoration: TextDecoration.underline,
                ),
              ),
              _loading == true
                  ? const CustomLoading()
                  : CustomButton(buttonText: 'Sign Up', buttonClicked: signUp),
              RichText(
                text: TextSpan(
                  text: 'Already have an account?  ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: 'Log In',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    setState(() {
      _loading = true;
    });

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
      // convert to user model
      _firestore
          .collection('User')
          .doc(emailcontroller.text.trim().toLowerCase())
          .set({
        'Name': namecontroller.text.trim(),
        'Entry Number': entrycontroller.text.trim(),
        'Email': emailcontroller.text.trim().toLowerCase(),
        'Phone': phonecontroller.text.trim(),
        'Type': type,
        'Department': dept,
        'Gender': gender,
        'Password': passwordcontroller.text.trim(),
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
      setState(() {
        _loading = false;
      });
    }

    // navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  void showAlertDialog(BuildContext context) {
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Terms and conditions"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
                '1. Eligibility: By using this app, you confirm that you are a student, faculty or staff of IIT Ropar.\n2. User Obligations: As a user of this app, you agree to provide accurate information, follow the honour code, and ensure the safety of your passengers and other users. False information can lead to disciplanary actions.\n3. Privacy: We respect your privacy and are committed to protecting your personal data. We will not use your personal data for any purpose such as monetary, other than that for which it was collected, unless we are required to do so by law.\n4. Cancellation Policy: If you need to cancel or leave a ride for any reason, you should do so through the carpool application as soon as possible. If you cancel or leave a ride, you will be flagged.\n5. Liability: The carpool application is not responsible for any monetary expenses, damages or losses that occur during a ride, whether to the driver, passengers or other users.\n6. Termination: The carpool application reserves the right to terminate your account at any time, without notice, if you violate the terms and conditions or for any other reason.'),
          ],
        ),
      ),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
