import 'package:carpool/screens/landing_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RequestsPage extends StatefulWidget {
  RequestsPage({Key? key}) : super(key: key);

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var user = FirebaseAuth.instance.currentUser!;

Future myRequestsID() async {
  user = FirebaseAuth.instance.currentUser!;
  List reqID = [];
  final QuerySnapshot<Map<String, dynamic>> _myDoc = await _firestore
      .collection('Requests')
      .where('Joiner', isEqualTo: user.email!)
      .get();
  for (var req in _myDoc.docs) {
    final data = req.data();
    reqID.add(data['Ride ID']);
  }
  return reqID;
}

Future myRequestsRide(List reqID) async {
  List reqRide = [];
  for (var id in reqID) {
    final document = await _firestore.collection('Offer').doc(id).get();
    final data = document.data();
    reqRide.add(data);
  }
  return reqRide;
}

Future myRequestsStatus() async {
  user = FirebaseAuth.instance.currentUser!;
  List reqStatus = [];
  final QuerySnapshot<Map<String, dynamic>> _myDoc = await _firestore
      .collection('Requests')
      .where('Joiner', isEqualTo: user.email!)
      .get();
  for (var req in _myDoc.docs) {
    final data = req.data();
    var id = data['Ride ID'];
    final document = await _firestore.collection('Offer').doc(id).get();
    final data1 = document.data();
    data1!['Status'] = data['Status'];
    data1['Req ID'] = req.id;
    reqStatus.add(data1);
  }
  return reqStatus;
}

class _RequestsPageState extends State<RequestsPage> {
  // List<dynamic> requestsID = [];
  // List<dynamic> requestsRide = [];
  List<dynamic> requestsStatus = [];
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      user = FirebaseAuth.instance.currentUser!;
    });
    super.initState();
    _isLoading = true;
    // myRequestsID().then((value) {
    //   setState(() {
    //     requestsID = value;
    //     myRequestsRide(requestsID).then((value) {
    //       setState(() {
    //         requestsRide = value;
    //         requestsRide.sort((a, b) => b['Date'].compareTo(a['Date']));
    //       });
    //     });
    //   });
    // });
    myRequestsStatus().then((value) {
      setState(() {
        requestsStatus = value;
        requestsStatus.sort((a, b) => b['Date'].compareTo(a['Date']));
      });
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final formatter = DateFormat('dd MMMM yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _isLoading == true
            ? Column(
                children: const [
                  SizedBox(
                    height: 12,
                  ),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : (requestsStatus.length == 0
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
                            'No Requests currently \nby you in any carpool.'),
                      ),
                    ],
                  )
                : Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: requestsStatus.length,
                        itemBuilder: ((BuildContext context, int index) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12)),
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
                                                    '${requestsStatus[index]['Source']}'),
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
                                                  '${requestsStatus[index]['Destination']}',
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
                                            Icon(Icons.question_mark),

                                            (requestsStatus[index]['Status'] ==
                                                    "Pending")
                                                ? Text(
                                                    '  ${requestsStatus[index]['Status']}',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                : ((requestsStatus[index]
                                                            ['Status'] ==
                                                        "Accepted")
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                        // color: Colors.green,
                                                        child: Text(
                                                          '  ${requestsStatus[index]['Status']}  ',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      )
                                                    : Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                        // color: Colors.red,
                                                        child: Text(
                                                          '  ${requestsStatus[index]['Status']}  ',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      )),

                                            // if (requestsStatus[index]['Status'] == "Pending") {
                                            //   Text(
                                            //   '  ${requestsStatus[index]['Status']}',
                                            //   style: const TextStyle(
                                            //       fontSize: 16,
                                            //       fontWeight: FontWeight.w400),
                                            // )
                                            // } else if (requestsStatus[index]['Status'] == "Accepted") {
                                            //   Text(
                                            //   '  ${requestsStatus[index]['Status']}',
                                            //   style: const TextStyle(
                                            //       fontSize: 16,
                                            //       fontWeight: FontWeight.w400),
                                            // ),
                                            // } else {

                                            // }
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
                                            Icon(Icons.email),
                                            Text(
                                              '  ${requestsStatus[index]['Email']}',
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
                                                Icon(Icons.date_range),
                                                Text(
                                                  '  ${formatDate(requestsStatus[index]['Date'].toDate().toString().split(' ')[0])}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                const Icon(Icons.timer),
                                                Text(
                                                  requestsStatus[index]['Time']
                                                              .toString()
                                                              .isEmpty ==
                                                          true
                                                      ? ''
                                                      : '  ${requestsStatus[index]['Time'].toString().substring(0, 5)}',
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
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Icon(Icons.directions_car),
                                                Text(
                                                  '  ${requestsStatus[index]['Car Type']}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Icon(Icons.people),
                                                Text(
                                                  '  ${int.parse(requestsStatus[index]['Total']) - int.parse(requestsStatus[index]['Available'])} / ${requestsStatus[index]['Total']}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        requestsStatus[index]['Status']
                                                    .toString() ==
                                                'Pending'
                                            ? Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .blue[300]!),
                                                    ),
                                                    child: const Text(
                                                      'Cancel Request',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Cancel Request'),
                                                              content: const Text(
                                                                  'Are you sure you want to cancel this request?'),
                                                              actions: [
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                          'No'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                          'Yes'),
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const LandingPage(),
                                                                      ),
                                                                    );
                                                                    await _firestore
                                                                        .collection(
                                                                            'Requests')
                                                                        .doc(requestsStatus[index]
                                                                            [
                                                                            'Req ID'])
                                                                        .delete();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                  ),
                                                ],
                                              )
                                            : Row(),

                                        // Row(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.center,
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.center,
                                        //   children: [
                                        //     TextButton(
                                        //         style: ButtonStyle(
                                        //           backgroundColor:
                                        //               MaterialStateProperty.all<
                                        //                       Color>(
                                        //                   Colors.blue[300]!),
                                        //         ),
                                        //         child: const Text(
                                        //           'Leave Ride',
                                        //           style: TextStyle(
                                        //             color: Colors.black,
                                        //             fontWeight: FontWeight.w400,
                                        //           ),
                                        //         ),
                                        //         onPressed: () {
                                        //           showDialog(
                                        //               context: context,
                                        //               builder: (BuildContext
                                        //                   context) {
                                        //                 return AlertDialog(
                                        //                   title: const Text(
                                        //                       'Leave Ride'),
                                        //                   content: const Text(
                                        //                       'Are you sure you want to leave this ride?'),
                                        //                   actions: [
                                        //                     TextButton(
                                        //                       onPressed: () {
                                        //                         Navigator.of(
                                        //                                 context)
                                        //                             .pop();
                                        //                       },
                                        //                       child: const Text(
                                        //                           'No'),
                                        //                     ),
                                        //                     TextButton(
                                        //                       onPressed:
                                        //                           () async {
                                        //                         await _firestore.collection(;)

                                        //                         }
                                        //                       },
                                        //                       child: const Text(
                                        //                           'Yes'),
                                        //                     ),
                                        //                   ],
                                        //                 );
                                        //               });
                                        //         }),
                                        //   ],
                                        // ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        })),
                  )),
      ],
    );
  }
}
