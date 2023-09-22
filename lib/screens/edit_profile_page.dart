import 'package:carpool/authentication/log_in_page.dart';
import 'package:carpool/screens/edit_name_page.dart';
import 'package:carpool/screens/edit_password_page.dart';
import 'package:carpool/screens/edit_phone.dart';
import 'package:carpool/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var user = FirebaseAuth.instance.currentUser;
final FirebaseAuth _auth = FirebaseAuth.instance;

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.blue[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            SizedBox(
              height: 28,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.blue[100],
                    elevation: 8,
                    child: InkWell(
                      splashColor: Colors.black,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditName()),
                        );
                      },
                      child: Column(
                        children: [
                          Ink.image(
                            image: Image.asset("assets/images/name.jpg").image,
                            fit: BoxFit.fill,
                            width: 150,
                            height: 150,
                          ),
                          Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 28,
                ),
                Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.blue[100],
                    elevation: 8,
                    child: InkWell(
                      splashColor: Colors.black,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPassword()),
                        );
                      },
                      child: Column(
                        children: [
                          Ink.image(
                            image: Image.asset("assets/images/password.jpeg")
                                .image,
                            fit: BoxFit.fill,
                            width: 150,
                            height: 150,
                          ),
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.blue[100],
                    elevation: 8,
                    child: InkWell(
                      splashColor: Colors.black,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditPhone()),
                        );
                      },
                      child: Column(
                        children: [
                          Ink.image(
                            image: Image.asset("assets/images/phone.jpg").image,
                            fit: BoxFit.fill,
                            width: 150,
                            height: 150,
                          ),
                          Text(
                            'Phone',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 28,
                ),
                Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.blue[100],
                    elevation: 8,
                    child: InkWell(
                      splashColor: Colors.black,
                      onTap: signOut,
                      child: Column(
                        children: [
                          Ink.image(
                            image:
                                Image.asset("assets/images/logout.jpeg").image,
                            fit: BoxFit.fill,
                            width: 150,
                            height: 150,
                          ),
                          Text(
                            'Log Out',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  Future signOut() async {
    // await FirebaseAuth.instance.signOut();
    // await CacheHelper.removeData(key: AppConstants.userKey);

    await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => StartScreen()),
            (route) => false));
    // SystemNavigator.pop();
    // await _deleteAppDir();
    // await _deleteCacheDir();
  }
}
