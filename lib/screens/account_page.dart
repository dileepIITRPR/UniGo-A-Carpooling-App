import 'dart:math';

import 'package:carpool/component/button.dart';
import 'package:carpool/models/user_model.dart';
import 'package:carpool/screens/edit_password_page.dart';
import 'package:carpool/screens/edit_phone.dart';
import 'package:carpool/screens/edit_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var user = FirebaseAuth.instance.currentUser!;

Future<UserModel> getUser(String email) async {
  final document = await _firestore
      .collection('User')
      .where('Email', isEqualTo: email)
      .get();
  final data = document.docs.map((e) => UserModel.fromSnapshot(e)).single;
  return data;
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = FirebaseAuth.instance.currentUser!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 28),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 42,
            margin: EdgeInsets.only(left: 16, right: 16),
            padding: EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person),
                const SizedBox(
                  width: 8,
                ),
                FutureBuilder(
                  future: getUser(user.email!),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      UserModel _user = snapshot.data as UserModel;
                      String _name = _user.name;
                      return Text(
                        _name,
                        style: TextStyle(fontSize: 18),
                      );
                    } else {
                      return Text('Error ');
                    }
                  }),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          // Container(
          //   margin: EdgeInsets.only(left: 16, right: 16),
          //   padding: EdgeInsets.only(left: 14, right: 14),
          //   decoration: BoxDecoration(
          //     border: Border.all(color: Colors.black),
          //     borderRadius: BorderRadius.circular(6),
          //   ),
          //   child: Row(
          //     // mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Icon(Icons.house),
          //       const SizedBox(
          //         width: 8,
          //       ),
          //       FutureBuilder(
          //         future: getUser(user.email!),
          //         builder: ((context, snapshot) {
          //           if (snapshot.hasData) {
          //             UserModel _user = snapshot.data as UserModel;
          //             String _entry = _user.entry_num;
          //             return Text(
          //               _entry,
          //               style: TextStyle(fontSize: 18),
          //             );
          //           } else {
          //             return Text('Error');
          //           }
          //         }),
          //       )
          //     ],
          //   ),
          // ),
          // const SizedBox(
          //   height: 12,
          // ),
          Container(
            height: 42,
            margin: EdgeInsets.only(left: 16, right: 16),
            padding: EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  user.email!,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            height: 42,
            margin: EdgeInsets.only(left: 16, right: 16),
            padding: EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_city),
                const SizedBox(
                  width: 8,
                ),
                FutureBuilder(
                  future: getUser(user.email!),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      UserModel _user = snapshot.data as UserModel;
                      String _type = _user.type;
                      String _dept = _user.dept;
                      if (_type == 'Staff') {
                        return Text(
                          _type,
                          style: TextStyle(fontSize: 18),
                        );
                      } else {
                        return Text(
                          '${_type} (${_dept} Department) ',
                          style: TextStyle(fontSize: 18),
                        );
                      }
                    } else {
                      return Text('Error');
                    }
                  }),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            height: 42,
            margin: EdgeInsets.only(left: 16, right: 16),
            padding: EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone),
                const SizedBox(
                  width: 8,
                ),
                FutureBuilder(
                  future: getUser(user.email!),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      UserModel _user = snapshot.data as UserModel;
                      String _phone = _user.phone;
                      return Text(
                        _phone,
                        style: TextStyle(fontSize: 18),
                      );
                    } else {
                      return Text('Error');
                    }
                  }),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            height: 42,
            margin: EdgeInsets.only(left: 16, right: 16),
            padding: EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flag),
                const SizedBox(
                  width: 8,
                ),
                FutureBuilder(
                  future: getUser(user.email!),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      UserModel _user = snapshot.data as UserModel;
                      String _gender = _user.gender;
                      return Text(
                        _gender,
                        style: TextStyle(fontSize: 18),
                      );
                    } else {
                      return Text('Error');
                    }
                  }),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          CustomButton(
              buttonText: "Profile Options",
              buttonClicked: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfile(),
                  ),
                );
              })
        ],
      ),
      // child: ,
    );
  }

  void signOut() async {
    FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }
}
