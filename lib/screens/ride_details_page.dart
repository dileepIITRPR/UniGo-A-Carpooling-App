import 'package:carpool/screens/offer_page.dart';
import 'package:carpool/utility/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var user = FirebaseAuth.instance.currentUser!;

Future getRide(String idDoc) async {
  var details = await _firestore.collection('Offer').doc(idDoc).get();
  return details.data()!;
}

Future<List> getUserRides(String idDoc) async {
  user = FirebaseAuth.instance.currentUser!;
  List<String> listUsers = [];
  var userC =
      _firestore.collection('Rides').where('Offer ID', isEqualTo: idDoc);
  var userQs = await userC.get();
  for (var us in userQs.docs) {
    if (us.data()["Email"] == user.email!) {
      continue;
    }
    listUsers.add(us.data()['Email']);
    var usQs = await _firestore
        .collection('User')
        .where('Email', isEqualTo: us.data()['Email'])
        .get();
    // phoneUser.add(usQs.docs.first.data()['Phone']);
    // userAllDetails.add(usQs.docs.first.data());
  }
  var details = await _firestore.collection('Offer').doc(idDoc).get();
  if (details.data()!['Email'] != user.email!) {
    listUsers.add(details.data()!['Email']);
    var usQs = await _firestore
        .collection('User')
        .where('Email', isEqualTo: details.data()!['Email'])
        .get();
    // phoneUser.add(usQs.docs.first.data()['Phone']);
    // userAllDetails.add(usQs.docs.first.data());
  }
  return listUsers;
}

Future<List> getUserAllDetails(String idDoc) async {
  user = FirebaseAuth.instance.currentUser!;
  List userAllDetails = [];
  var userC =
      _firestore.collection('Rides').where('Offer ID', isEqualTo: idDoc);
  var userQs = await userC.get();
  for (var us in userQs.docs) {
    if (us.data()["Email"] == user.email!) {
      continue;
    }
    // listUsers.add(us.data()['Email']);
    var usQs = await _firestore
        .collection('User')
        .where('Email', isEqualTo: us.data()['Email'])
        .get();
    // phoneUser.add(usQs.docs.first.data()['Phone']);
    userAllDetails.add(usQs.docs.first.data());
  }
  var details = await _firestore.collection('Offer').doc(idDoc).get();
  if (details.data()!['Email'] != user.email!) {
    // listUsers.add(details.data()!['Email']);
    var usQs = await _firestore
        .collection('User')
        .where('Email', isEqualTo: details.data()!['Email'])
        .get();
    // phoneUser.add(usQs.docs.first.data()['Phone']);
    userAllDetails.add(usQs.docs.first.data());
  }
  return userAllDetails;
}

Future<List> getUserPhone(String idDoc) async {
  user = FirebaseAuth.instance.currentUser!;
  List<String> phoneUser = [];
  var userC =
      _firestore.collection('Rides').where('Offer ID', isEqualTo: idDoc);
  var userQs = await userC.get();
  for (var us in userQs.docs) {
    if (us.data()["Email"] == user.email!) {
      continue;
    }
    // listUsers.add(us.data()['Email']);
    var usQs = await _firestore
        .collection('User')
        .where('Email', isEqualTo: us.data()['Email'])
        .get();
    phoneUser.add(usQs.docs.first.data()['Phone']);
    // userAllDetails.add(usQs.docs.first.data());
  }
  var details = await _firestore.collection('Offer').doc(idDoc).get();
  if (details.data()!['Email'] != user.email!) {
    // listUsers.add(details.data()!['Email']);
    var usQs = await _firestore
        .collection('User')
        .where('Email', isEqualTo: details.data()!['Email'])
        .get();
    phoneUser.add(usQs.docs.first.data()['Phone']);
    // userAllDetails.add(usQs.docs.first.data());
  }
  return phoneUser;
}

class RideDetails extends StatefulWidget {
  String rideId;
  RideDetails({Key? key, required this.rideId}) : super(key: key);

  @override
  State<RideDetails> createState() => _RideDetailsState();
}

class _RideDetailsState extends State<RideDetails> {
  List<dynamic> allUsers = [];
  List<dynamic> phoneUser = [];
  List userAllDetails = [];
  Map<String, dynamic> rideDetails = <String, dynamic>{};
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      user = FirebaseAuth.instance.currentUser!;
    });
    super.initState();
    _isLoading = true;
    getUserRides(widget.rideId).then((value) {
      setState(() {
        allUsers = value;
      });
    });
    getRide(widget.rideId).then((value) {
      setState(() {
        rideDetails = value;
      });
    });
    getUserPhone(widget.rideId).then((value) {
      setState(() {
        phoneUser = value;
      });
    });
    getUserAllDetails(widget.rideId).then((value) {
      setState(() {
        userAllDetails = value;
      });
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future _makeCall(String call) async {
    var url = Uri.parse("tel:$call");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future _makeWhatsApp(String phone) async {
    var url = Uri.parse("whatsapp://send?phone=91$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future _makeEmail(String email) async {
    var url = Uri.parse("mailto:$email");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Details', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.blue[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
      ),
      body:
          // Column(
          //   children: [
          // Text('Details of fellow passengers: '),
          Column(
        children: [
          _isLoading == true
              ? Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Center(child: CircularProgressIndicator()),
                  ],
                )
              : (allUsers.isEmpty
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 28,
                        ),
                        Ink.image(
                          image: Image.asset("assets/images/noshow.png").image,
                          fit: BoxFit.fill,
                          width: 220,
                          height: 230,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Center(
                          child: Text(
                            'No users have joined the ride yet.',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: allUsers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                // color: Colors.blue[100],
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    //set border radius more than 50% of height and width to make circle
                                  ),
                                  borderOnForeground: true,
                                  color: Colors.white,
                                  shadowColor: Colors.blue,
                                  elevation: 32,
                                  child: InkWell(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(''),
                                        Text(
                                          '  ${userAllDetails[index]['Name']}  \n  ${allUsers[index]} \n  ${phoneUser[index]} \n  ${userAllDetails[index]['Gender']}: ${userAllDetails[index]['Type']}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                _makeCall(phoneUser[index]);
                                              },
                                              icon: Icon(Icons.call),
                                              // color: Colors.blue,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _makeWhatsApp(phoneUser[index]);
                                              },
                                              icon: Icon(Icons.whatsapp),
                                              // color: Colors.blue,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _makeEmail(
                                                    allUsers[index].toString());
                                              },
                                              icon: Icon(Icons.email),
                                              // color: Colors.blue,
                                            ),
                                          ],
                                        ),
                                        // Text(''),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )),
        ],
      ),
      //   ],
      // ),
      // SingleChildScrollView(
      //   padding: EdgeInsets.only(top: 18),
      //   child: Column(
      //     children: [
      //       Card(
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(12),
      //           //set border radius more than 50% of height and width to make circle
      //         ),
      //         borderOnForeground: true,
      //         color: Colors.blue[100],
      //         elevation: 10,
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.stretch,
      //           children: [
      //             Text(
      //               '  ${rideDetails['Source']}\n  ↓ \n  ${rideDetails['Destination']}',
      //               style: const TextStyle(
      //                   fontSize: 18, fontWeight: FontWeight.bold),
      //             ),
      //             // Text(
      //             //     '  Date: ${rideDetails['Date'].toDate().toString().split(' ')[0]}'),
      //             Text('  Car Type: ${rideDetails['Car Type']}'),
      //             Text('  Available Seats: ${rideDetails['Available']}'),
      //             Text('  Offered by: ${rideDetails['Email']}'),
      //           ],
      //         ),
      //       ),
      //       const SizedBox(
      //         height: 12,
      //       ),
      // Expanded(
      //   child:
      // ListView.builder(
      //   padding: const EdgeInsets.all(8),
      //   itemCount: allUsers.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     return Container(
      //       alignment: Alignment.topLeft,
      //       decoration: const BoxDecoration(
      //         color: Colors.white,
      //         // borderRadius: BorderRadius.circular(4),
      //       ),
      //       child: Center(
      //         child: Column(
      //           children: [
      //             Text(
      //               phoneUser[index],
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
      // ),
      //     ],
      //   ),
      // ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Text(
      //     'Tap to call...',
      //     textAlign: TextAlign.right,
      //   ),
      // ),
    );
  }
}
