import 'package:carpool/utility/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var user = FirebaseAuth.instance.currentUser!;

Future<List> getUserDetails(String Id) async {
  user = FirebaseAuth.instance.currentUser!;
  List userDetails = [];
  var reqCollection = await _firestore
      .collection('Requests')
      .where('Ride ID', isEqualTo: Id)
      .where('Status', isEqualTo: 'Pending')
      .get();

  for (var req in reqCollection.docs) {
    var reqData = req.data();
    var joinerEmail = reqData['Joiner'];
    var joinerDetails = await _firestore
        .collection('User')
        .where('Email', isEqualTo: joinerEmail)
        .get();
    if (joinerDetails.docs.isNotEmpty) {
      userDetails.add(joinerDetails.docs.first.data());
    }
  }
  return userDetails;
}

class RequestsDetails extends StatefulWidget {
  String rideId;
  RequestsDetails({Key? key, required this.rideId}) : super(key: key);

  @override
  State<RequestsDetails> createState() => _RequestsDetailsState();
}

class _RequestsDetailsState extends State<RequestsDetails> {
  List<dynamic> userDetails = [];

  @override
  void initState() {
    setState(() {
      user = FirebaseAuth.instance.currentUser!;
    });
    super.initState();
    getUserDetails(widget.rideId).then((value) {
      setState(() {
        userDetails = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Requests Details', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.blue[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
      ),
      body: Column(
        children: [
          userDetails.length == 0
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
                        'No users have requested to join this ride. ',
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
                      itemCount: userDetails.length,
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
                                        '  ${userDetails[index]['Name']}  \n  ${userDetails[index]['Email']} \n  ${userDetails[index]['Phone']} \n  ${userDetails[index]['Gender']}: ${userDetails[index]['Type']}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.blue[300]!),
                                            ),
                                            child: const Text(
                                              'Accept',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            onPressed: () async {
                                              // get Offer details

                                              var offerCollection =
                                                  await _firestore
                                                      .collection('Offer')
                                                      .doc(widget.rideId)
                                                      .get();
                                              var offerData =
                                                  offerCollection.data();

                                              var seats = int.parse(
                                                  offerData!['Available']);
                                              assert(seats is int);
                                              // String seats =
                                              //     offerData!['Available'];

                                              if (seats == 0) {
                                                offerData['Status'] =
                                                    'Rejected';
                                                Utils.showSnackBar(
                                                    'Ride Full cannot accept');
                                              } else {
                                                // add to Rides collection
                                                await _firestore
                                                    .collection('Rides')
                                                    .doc()
                                                    .set({
                                                  'Offer ID': widget.rideId,
                                                  'Email': userDetails[index]
                                                      ['Email']
                                                });
                                                // change Status to Accepted in Requests collection
                                                _firestore
                                                    .collection('Requests')
                                                    .where('Ride ID',
                                                        isEqualTo:
                                                            widget.rideId)
                                                    .where('Joiner',
                                                        isEqualTo:
                                                            userDetails[index]
                                                                ['Email'])
                                                    .get()
                                                    .then((value) async {
                                                  value.docs.first.reference
                                                      .update({
                                                    'Status': 'Accepted'
                                                  });
                                                });
                                                seats--;
                                                offerData['Available'] =
                                                    seats.toString();

                                                await _firestore
                                                    .collection('Offer')
                                                    .doc(widget.rideId)
                                                    .set(offerData);
                                                Utils.showSnackBar(
                                                    'Join Request Accepted');
                                              }
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const SizedBox(
                                            width: 24,
                                          ),
                                          TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.blue[300]!),
                                            ),
                                            child: const Text(
                                              'Reject',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            onPressed: () {
                                              // change Status to Rejected in Requests collection
                                              _firestore
                                                  .collection('Requests')
                                                  .where('Ride ID',
                                                      isEqualTo: widget.rideId)
                                                  .where('Joiner',
                                                      isEqualTo:
                                                          userDetails[index]
                                                              ['Email'])
                                                  .get()
                                                  .then((value) {
                                                value.docs.first.reference
                                                    .update(
                                                        {'Status': 'Rejected'});
                                              });
                                              Utils.showSnackBar(
                                                  'Join Request Rejected');
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      // Row(
                                      //   children: [
                                      //     IconButton(
                                      //       onPressed: () {
                                      //         _makeCall(phoneUser[index]);
                                      //       },
                                      //       icon: Icon(Icons.call),
                                      //       // color: Colors.blue,
                                      //     ),
                                      //     IconButton(
                                      //       onPressed: () {
                                      //         _makeWhatsApp(phoneUser[index]);
                                      //       },
                                      //       icon: Icon(Icons.whatsapp),
                                      //       // color: Colors.blue,
                                      //     ),
                                      //   ],
                                      // ),
                                      // Text(''),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
        ],
      ),
    );
  }
}
