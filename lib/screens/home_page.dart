import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../component/button.dart';
import 'account_page.dart';
import 'join_page.dart';
import 'my_rides_page.dart';
import 'offer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var user = FirebaseAuth.instance.currentUser!;

Future<List> getRides() async {
  final rides = await _firestore
      .collection('Offer')
      .orderBy('Timestamp', descending: true)
      .limit(2)
      .get();
  List rideList = [];
  for (var ride in rides.docs) {
    Timestamp t = ride.data()['Timestamp'];
    DateTime d = t.toDate();

    rideList.add(ride.data());
  }
  return rideList;
}

class _HomePageState extends State<HomePage> {
  late User _user;
  List recentRides = [];
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      user = FirebaseAuth.instance.currentUser!;
    });
    _isLoading = true;
    getRides().then((value) {
      setState(() {
        recentRides = value;
      });
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final formatter = DateFormat('dd MMMM yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //   'Logged in as ${user.email!}',
          //   style: const TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 18,
          //   ),
          // ),
          // const SizedBox(
          //   height: 54,
          // ),
          const SizedBox(
            height: 16,
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
                        MaterialPageRoute(builder: (context) => OfferPage()),
                      );
                    },
                    child: Column(
                      children: [
                        Ink.image(
                          image: Image.asset("assets/images/offer1.png").image,
                          // image: Image.asset("assets/images/offer.jpeg").image,
                          fit: BoxFit.cover,
                          width: 163,
                          height: 160,
                        ),
                        Text(
                          'Offer',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
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
                        MaterialPageRoute(builder: (context) => JoinPage()),
                      );
                    },
                    child: Column(
                      children: [
                        Ink.image(
                          image: Image.asset("assets/images/join1.png").image,
                          // image: Image.asset("assets/images/join.jpg").image,
                          fit: BoxFit.cover,
                          width: 163,
                          height: 160,
                        ),
                        Text(
                          'Join',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Center(
          //   child: Material(
          //     borderRadius: BorderRadius.circular(12),
          //     clipBehavior: Clip.antiAliasWithSaveLayer,
          //     color: Colors.blue[100],
          //     elevation: 8,
          //     child: InkWell(
          //       splashColor: Colors.black,
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => OfferPage()),
          //         );
          //       },
          //       child: Column(
          //         children: [
          //           Ink.image(
          //             image: Image.asset("assets/images/offer1.png").image,
          //             // image: Image.asset("assets/images/offer.jpeg").image,
          //             fit: BoxFit.cover,
          //             width: 205,
          //             height: 200,
          //           ),
          //           Text(
          //             'Offer',
          //             style: TextStyle(
          //               fontSize: 24,
          //               fontWeight: FontWeight.w500,
          //               height: 1.4,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // // CustomButton(
          // //     buttonText: 'Offer',
          // //     buttonClicked: () {
          // //       Navigator.push(
          // //         context,
          // //         MaterialPageRoute(builder: (context) => OfferPage()),
          // //       );
          // //     }),
          // const SizedBox(
          //   height: 48,
          // ),
          // Center(
          //   child: Material(
          //     borderRadius: BorderRadius.circular(12),
          //     clipBehavior: Clip.antiAliasWithSaveLayer,
          //     color: Colors.blue[100],
          //     elevation: 8,
          //     child: InkWell(
          //       splashColor: Colors.black,
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => JoinPage()),
          //         );
          //       },
          //       child: Column(
          //         children: [
          //           Ink.image(
          //             image: Image.asset("assets/images/join1.png").image,
          //             // image: Image.asset("assets/images/join.jpg").image,
          //             fit: BoxFit.cover,
          //             width: 205,
          //             height: 200,
          //           ),
          //           Text(
          //             'Join',
          //             style: TextStyle(
          //               fontSize: 24,
          //               fontWeight: FontWeight.w500,
          //               height: 1.4,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // // CustomButton(
          // //     buttonText: 'Join',
          // //     buttonClicked: () {
          // //       Navigator.push(
          // //         context,
          // //         MaterialPageRoute(builder: (context) => JoinPage()),
          // //       );
          // //     }),
          // CustomButton(
          //     buttonText: 'My Rides',
          //     buttonClicked: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => MyRidesPage()),
          //       );
          //     }),
          // CustomButton(
          //     buttonText: 'Account',
          //     buttonClicked: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => AccountPage()),
          //       );
          //     }),
          // CustomButton(buttonText: 'Log Out', buttonClicked: signOut),
          const SizedBox(
            height: 24,
          ),
          const Divider(
            height: 16,
            thickness: 2,
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Recent Offerings',
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              fontWeight: FontWeight.w500,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          _isLoading == true
              ? Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Center(child: CircularProgressIndicator()),
                  ],
                )
              : SizedBox(
                  height: 500,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: recentRides.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        alignment: Alignment.topLeft,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    //set border radius more than 50% of height and width to make circle
                                  ),
                                  borderOnForeground: true,
                                  color: Colors.white,
                                  elevation: 32,
                                  shadowColor: Colors.blue,
                                  child: InkWell(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.all(8),
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[100],
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                    bottomLeft:
                                                        Radius.circular(12),
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                child: Text(
                                                    '${recentRides[index]['Source']}'),
                                              ),
                                            ),
                                            Icon(Icons.arrow_forward),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.all(8),
                                                padding: EdgeInsets.all(8),
                                                // height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[100],
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(12),
                                                    bottomRight:
                                                        Radius.circular(12),
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                child: Text(
                                                  '${recentRides[index]['Destination']}',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Icon(Icons.date_range),
                                            Text(
                                              '  ${formatDate(recentRides[index]['Date'].toDate().toString().split(' ')[0])}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Icon(Icons.directions_car),
                                                Text(
                                                  '  ${recentRides[index]['Car Type']}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Icon(Icons.people),
                                                Text(
                                                  '  ${recentRides[index]['Available']}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
        ],
      ),
    );
  }

  // void signOut() async {
  //   FirebaseAuth.instance.signOut();
  // }
}

// class _HomePageState extends State<HomePage> {
//   late User _user;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Page'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(18),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Text(
//             //   'Logged in as ${user.email!}',
//             //   style: const TextStyle(
//             //     fontWeight: FontWeight.bold,
//             //     fontSize: 18,
//             //   ),
//             // ),
//             CustomButton(
//                 buttonText: 'Offer',
//                 buttonClicked: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => OfferPage()),
//                   );
//                 }),
//             CustomButton(
//                 buttonText: 'Join',
//                 buttonClicked: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => JoinPage()),
//                   );
//                 }),
//             // CustomButton(
//             //     buttonText: 'My Rides',
//             //     buttonClicked: () {
//             //       Navigator.push(
//             //         context,
//             //         MaterialPageRoute(builder: (context) => MyRidesPage()),
//             //       );
//             //     }),
//             // CustomButton(
//             //     buttonText: 'Account',
//             //     buttonClicked: () {
//             //       Navigator.push(
//             //         context,
//             //         MaterialPageRoute(builder: (context) => AccountPage()),
//             //       );
//             //     }),
//             // CustomButton(buttonText: 'Log Out', buttonClicked: signOut),
//           ],
//         ),
//       ),
//     );
//   }

//   // void signOut() async {
//   //   FirebaseAuth.instance.signOut();
//   // }
// }
