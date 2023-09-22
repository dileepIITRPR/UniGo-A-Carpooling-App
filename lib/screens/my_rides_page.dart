import 'package:carpool/screens/my_joined_rides.dart';
import 'package:carpool/screens/my_offered_rides.dart';
import 'package:carpool/screens/ride_details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyRidesPage extends StatefulWidget {
  const MyRidesPage({super.key});

  @override
  State<MyRidesPage> createState() => _MyRidesPageState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;

// Future<List> getRides() async {
//   List<dynamic> ridesList = [];
//   var rideCollection =
//       _firestore.collection('Rides').where('Email', isEqualTo: user.email!);
//   var rideQuerySnapshot = await rideCollection.get();
//   for (var doc in rideQuerySnapshot.docs) {
//     Map<String, dynamic> data = doc.data();
//     ridesList.add(data['Offer ID']);
//   }
//   var offerCollection =
//       _firestore.collection('Offer').where('Email', isEqualTo: user.email!);
//   var offerQuerySnapshot = await offerCollection.get();
//   for (var doc in offerQuerySnapshot.docs) {
//     ridesList.add(doc.id);
//   }
//   return ridesList;
// }

// Future<List> getMyRides(List<dynamic> myRides) async {
//   List<dynamic> allRides = [];
//   for (int i = 0; i < myRides.length; i++) {
//     final document = await _firestore.collection('Offer').doc(myRides[i]).get();
//     final data = document.data();
//     allRides.add(data);
//   }
//   return allRides;
// }

class _MyRidesPageState extends State<MyRidesPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(
            //   height: 54,
            // ),
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
                        builder: (context) => MyOfferedRides(),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      // Ink.image(
                      //   image: Image.asset("assets/images/offer1.png").image,
                      //   // image: Image.asset("assets/images/offer.jpeg").image,
                      //   fit: BoxFit.cover,
                      //   width: 205,
                      //   height: 200,
                      // ),
                      Text(
                        '\nMy Offered Rides\n',
                        textAlign: TextAlign.center,
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
            // CustomButton(
            //     buttonText: 'Offer',
            //     buttonClicked: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => OfferPage()),
            //       );
            //     }),
            const SizedBox(
              height: 48,
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
                        builder: (context) => MyJoinedRides(),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ink.image(
                      //   image: Image.asset("assets/images/join1.png").image,
                      //   // image: Image.asset("assets/images/join.jpg").image,
                      //   fit: BoxFit.cover,
                      //   width: 205,
                      //   height: 200,
                      // ),
                      Text(
                        '\nMy Joined Rides\n',
                        textAlign: TextAlign.center,
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
      ),
    );
  }

  // List<dynamic> myRides = [];
  // List<dynamic> allRides = [];
  // @override
  // void initState() {
  //   super.initState();
  //   getRides().then((List val) {
  //     setState(() {
  //       myRides = val;
  //       getMyRides(myRides).then((List val) {
  //         setState(() {
  //           allRides = val;
  //         });
  //       });
  //     });
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     children: [
  //       allRides.isEmpty
  //           ? const Center(
  //               child: Text('No rides joined by you.'),
  //             )
  //           : Expanded(
  //               child: ListView.builder(
  //                 padding: const EdgeInsets.all(8),
  //                 itemCount: allRides.length,
  //                 itemBuilder: ((BuildContext context, int index) {
  //                   return Column(
  //                     children: [
  //                       SizedBox(
  //                         height: 16,
  //                       ),
  //                       Container(
  //                         alignment: Alignment.center,
  //                         decoration: BoxDecoration(
  //                             border: Border.all(color: Colors.black),
  //                             color: Colors.white,
  //                             borderRadius: BorderRadius.circular(12)),
  //                         child: Card(
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(12),
  //                             //set border radius more than 50% of height and width to make circle
  //                           ),
  //                           borderOnForeground: true,
  //                           color: Colors.white,
  //                           elevation: 32,
  //                           shadowColor: Colors.blue,
  //                           child: InkWell(
  //                             onTap: () {
  //                               Navigator.of(context).push(
  //                                 MaterialPageRoute(
  //                                   builder: (context) => RideDetails(
  //                                     rideId: myRides[index],
  //                                   ),
  //                                 ),
  //                               );
  //                             },
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.stretch,
  //                               children: [
  //                                 Row(
  //                                   children: [
  //                                     Expanded(
  //                                       child: Container(
  //                                         margin: EdgeInsets.all(8),
  //                                         padding: EdgeInsets.all(8),
  //                                         decoration: BoxDecoration(
  //                                           color: Colors.blue[100],
  //                                           borderRadius:
  //                                               const BorderRadius.only(
  //                                             topLeft: Radius.circular(12),
  //                                             bottomLeft: Radius.circular(12),
  //                                           ),
  //                                           border: Border.all(
  //                                             color: Colors.black,
  //                                           ),
  //                                         ),
  //                                         child: Text(
  //                                             '${allRides[index]['Source']}'),
  //                                       ),
  //                                     ),
  //                                     Icon(Icons.arrow_forward),
  //                                     Expanded(
  //                                       child: Container(
  //                                         margin: EdgeInsets.all(8),
  //                                         padding: EdgeInsets.all(8),
  //                                         // height: 20,
  //                                         decoration: BoxDecoration(
  //                                           color: Colors.blue[100],
  //                                           borderRadius:
  //                                               const BorderRadius.only(
  //                                             topRight: Radius.circular(12),
  //                                             bottomRight: Radius.circular(12),
  //                                           ),
  //                                           border: Border.all(
  //                                             color: Colors.black,
  //                                           ),
  //                                         ),
  //                                         child: Text(
  //                                           '${allRides[index]['Destination']}',
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 8,
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     SizedBox(
  //                                       width: 8,
  //                                     ),
  //                                     Icon(Icons.date_range),
  //                                     Text(
  //                                       '  ${allRides[index]['Date'].toDate().toString().split(' ')[0]}',
  //                                       style: const TextStyle(
  //                                           fontSize: 16,
  //                                           fontWeight: FontWeight.w400),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 8,
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Row(
  //                                       children: [
  //                                         SizedBox(
  //                                           width: 8,
  //                                         ),
  //                                         Icon(Icons.directions_car),
  //                                         Text(
  //                                           '  ${allRides[index]['Car Type']}',
  //                                           style: const TextStyle(
  //                                               fontSize: 16,
  //                                               fontWeight: FontWeight.w400),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     Row(
  //                                       children: [
  //                                         SizedBox(
  //                                           width: 8,
  //                                         ),
  //                                         Icon(Icons.people),
  //                                         Text(
  //                                           '  ${allRides[index]['Available']}',
  //                                           style: const TextStyle(
  //                                               fontSize: 16,
  //                                               fontWeight: FontWeight.w400),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 SizedBox(
  //                                   height: 8,
  //                                 ),
  //                                 //   ListTile(
  //                                 //     title: Column(
  //                                 //       children: [
  //                                 //         SizedBox(
  //                                 //           width: 8,
  //                                 //         ),
  //                                 //         Icon(Icons.directions_car),
  //                                 //         Text(
  //                                 //           '  ${allRides[index]['Car Type']}',
  //                                 //           style: const TextStyle(
  //                                 //               fontSize: 16,
  //                                 //               fontWeight: FontWeight.bold),
  //                                 //         ),
  //                                 //       ],
  //                                 //     ),
  //                                 //     trailing: Column(
  //                                 //       children: [
  //                                 //         SizedBox(
  //                                 //           width: 8,
  //                                 //         ),
  //                                 //         Icon(Icons.person),
  //                                 //         Text(
  //                                 //           '  ${allRides[index]['Available']}',
  //                                 //           style: const TextStyle(
  //                                 //               fontSize: 16,
  //                                 //               fontWeight: FontWeight.bold),
  //                                 //         ),
  //                                 //       ],
  //                                 //     ),
  //                                 //   ),
  //                                 //   Row(
  //                                 //     children: [
  //                                 //       SizedBox(
  //                                 //         width: 8,
  //                                 //       ),
  //                                 //       Icon(Icons.directions_car),
  //                                 //       Text(
  //                                 //         '  ${allRides[index]['Car Type']}',
  //                                 //         style: const TextStyle(
  //                                 //             fontSize: 16,
  //                                 //             fontWeight: FontWeight.bold),
  //                                 //       ),
  //                                 //     ],
  //                                 //   ),
  //                                 //   const SizedBox(
  //                                 //     height: 8,
  //                                 //   ),
  //                                 //   Row(
  //                                 //     children: [
  //                                 //       SizedBox(
  //                                 //         width: 8,
  //                                 //       ),
  //                                 //       Icon(Icons.person),
  //                                 //       Text(
  //                                 //         '  ${allRides[index]['Available']}',
  //                                 //         style: const TextStyle(
  //                                 //             fontSize: 16,
  //                                 //             fontWeight: FontWeight.bold),
  //                                 //       ),
  //                                 //     ],
  //                                 //   ),
  //                               ],
  //                               // children: [
  //                               //   Text(''),
  //                               //   Text(
  //                               //     '  ${allRides[index]['Source']}\n  ↓ \n  ${allRides[index]['Destination']}',
  //                               //     style: const TextStyle(
  //                               //         fontSize: 16,
  //                               //         fontWeight: FontWeight.bold),
  //                               //   ),
  //                               //   Text(
  //                               //       '  Date: ${allRides[index]['Date'].toDate().toString().split(' ')[0]}'),
  //                               //   Text(
  //                               //       '  Car Type: ${allRides[index]['Car Type']}'),
  //                               //   Text(
  //                               //       '  Available: ${allRides[index]['Available']}'),
  //                               //   Text(''),
  //                               //   // Text('Offered by: ${allRides[index]['Email']}'),
  //                               // ],
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   );
  //                 }),
  //               ),
  //             ),
  //     ],

  //     // bottomNavigationBar: BottomAppBar(
  //     //   child: Text(
  //     //     'Tap to get passenger details...',
  //     //     textAlign: TextAlign.right,
  //     //   ),
  //     // ),
  //   );
  // }
}
