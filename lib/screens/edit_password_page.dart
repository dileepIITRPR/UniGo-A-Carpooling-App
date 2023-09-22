import 'package:carpool/component/button.dart';
import 'package:carpool/component/loading.dart';
import 'package:carpool/utility/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var user = FirebaseAuth.instance.currentUser!;

class _EditPasswordState extends State<EditPassword> {
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newPasswordController1 = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = false;
    setState(() {
      user = FirebaseAuth.instance.currentUser!;
    });
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Password', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.blue[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 18,
          right: 18,
          top: 48,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: oldPasswordController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Old password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: newPasswordController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.done,
                // obscureText: !_passwordVisible,
                decoration: const InputDecoration(
                  labelText: 'New password',
                  border: OutlineInputBorder(),
                  // suffixIcon: IconButton(
                  //   icon: Icon(
                  //     // Based on passwordVisible state choose the icon
                  //     _passwordVisible
                  //         ? Icons.visibility
                  //         : Icons.visibility_off,
                  //     color: Colors.black,
                  //   ),
                  //   onPressed: () {
                  //     // Update the state i.e. toogle the state of passwordVisible variable
                  //     setState(() {
                  //       _passwordVisible = !_passwordVisible;
                  //     });
                  //   },
                  // ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) => val != null && val.length < 8
                    ? 'Enter min. 8 characters'
                    : null,
              ),
              const SizedBox(
                height: 8,
              ),
              // TextFormField(
              //   controller: newPasswordController1,
              //   cursorColor: Colors.black,
              //   textInputAction: TextInputAction.done,
              //   // obscureText: !_passwordVisible,
              //   decoration: const InputDecoration(
              //     labelText: 'Renter New password',
              //     border: OutlineInputBorder(),
              //     // suffixIcon: IconButton(
              //     //   icon: Icon(
              //     //     // Based on passwordVisible state choose the icon
              //     //     _passwordVisible
              //     //         ? Icons.visibility
              //     //         : Icons.visibility_off,
              //     //     color: Colors.black,
              //     //   ),
              //     //   onPressed: () {
              //     //     // Update the state i.e. toogle the state of passwordVisible variable
              //     //     setState(() {
              //     //       _passwordVisible = !_passwordVisible;
              //     //     });
              //     //   },
              //     // ),
              //   ),
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   validator: (val) => val != null && val.length < 8
              //       ? 'Enter min. 8 characters'
              //       : null,
              // ),
              _loading == true
                  ? const CustomLoading()
                  : CustomButton(
                      buttonText: 'Change',
                      buttonClicked: () => showAlertDialog(context),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        // setState(() {
        //   _loading = false;
        // });
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      onPressed: changePassword,
      child: const Text('Continue'),
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Confirm change password?"),
      // content: Text(""),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // setState(() {
        //   _loading = true;
        // });
        return alert;
      },
    );
  }

  Future changePassword() async {
    String email = user.email!;
    // var userCollection =
    //     _firestore.collection('User').where('Email', isEqualTo: email);
    var userQuerySnapshot = await _firestore
        .collection('User')
        .where('Email', isEqualTo: email)
        .get();
    Map<String, dynamic> data = userQuerySnapshot.docs[0].data();
    String oldPass = data['Password'].toString();
    if (oldPass == oldPasswordController.text.trim()) {
      await user
          .updatePassword(newPasswordController.text.trim())
          .then((_) => debugPrint('SUCCESS'))
          .catchError((error) => print('ERROR ' + error.toString()));
      // var qs = await _firestore
      //     .collection('User')
      //     .where('Email', isEqualTo: email)
      //     .get();
      // String docId = qs.docs.first.id;
      await _firestore
          .collection('User')
          .doc(user.email!)
          .update({'Password': newPasswordController.text.trim()});
      Utils.showSnackBar('Password changed successfully');
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      Utils.showSnackBar('Old password is incorrect');
      Navigator.pop(context);
    }
    setState(() {
      _loading = false;
    });
  }
}
