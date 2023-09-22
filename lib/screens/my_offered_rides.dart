import 'package:carpool/component/button.dart';
import 'package:carpool/screens/requests_details_page.dart';
import 'package:carpool/screens/ride_details_page.dart';
import 'package:carpool/utility/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyOfferedRides extends StatefulWidget {
  MyOfferedRides({Key? key}) : super(key: key);
  final String restorationId = "main";
  @override
  State<MyOfferedRides> createState() => _MyOfferedRidesState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var user = FirebaseAuth.instance.currentUser!;

Future<List> getRides() async {
  user = FirebaseAuth.instance.currentUser!;
  List<dynamic> ridesList = [];

  var offerCollection =
      _firestore.collection('Offer').where('Email', isEqualTo: user.email!);
  var offerQuerySnapshot = await offerCollection.get();
  for (var doc in offerQuerySnapshot.docs) {
    ridesList.add(doc.id);
  }
  return ridesList;
}

Future<List> getMyRides(List<dynamic> myRides) async {
  List<dynamic> allRides = [];
  for (int i = 0; i < myRides.length; i++) {
    final document = await _firestore.collection('Offer').doc(myRides[i]).get();
    final data = document.data();
    data!['Ride ID'] = myRides[i];
    allRides.add(data);
  }
  return allRides;
}

class _MyOfferedRidesState extends State<MyOfferedRides> with RestorationMixin {
  final formKey = GlobalKey<FormState>();
  List<dynamic> myRides = [];
  List<dynamic> allRides = [];
  List<dynamic> allOriginalRides = [];
  bool _isLoading = false;
  TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      user = FirebaseAuth.instance.currentUser!;
    });
    _isLoading = true;
    dateCheck = 0;
    getRides().then((List val) {
      setState(() {
        myRides = val;
        getMyRides(myRides).then((List val) {
          setState(() {
            allRides = val;
            allRides.sort((a, b) => b['Date'].compareTo(a['Date']));
            allOriginalRides = val;
            allOriginalRides.sort((a, b) => b['Date'].compareTo(a['Date']));
          });
        });
      });
    });
    Future.delayed(const Duration(seconds: 3), () {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Offered Rides',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.blue[300],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_list),
            color: Colors.black,
            onPressed: () {
              showFilterDialog(context);
            },
          ),
        ],
      ),
      body: Column(
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
              : (allRides.isEmpty
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
                          child: Text('No rides offered by you.'),
                        ),
                      ],
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: allRides.length,
                        itemBuilder: ((BuildContext context, int index) {
                          return Column(
                            children: [
                              const SizedBox(
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
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => RideDetails(
                                            rideId: allRides[index]['Ride ID'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.all(8),
                                                padding:
                                                    const EdgeInsets.all(8),
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
                                                    '${allRides[index]['Source']}'),
                                              ),
                                            ),
                                            const Icon(Icons.arrow_forward),
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.all(8),
                                                padding:
                                                    const EdgeInsets.all(8),
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
                                                  '${allRides[index]['Destination']}',
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
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                const Icon(Icons.date_range),
                                                Text(
                                                  '  ${formatDate(allRides[index]['Date'].toDate().toString().split(' ')[0])}',
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
                                                  allRides[index]['Time']
                                                              .toString()
                                                              .isEmpty ==
                                                          true
                                                      ? ''
                                                      : '  ${allRides[index]['Time'].toString().substring(0, 5)}',
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
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                const Icon(
                                                    Icons.directions_car),
                                                Text(
                                                  '  ${allRides[index]['Car Type']}',
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
                                                const Icon(Icons.people),
                                                Text(
                                                  '  ${int.parse(allRides[index]['Total']) - int.parse(allRides[index]['Available'])} / ${allRides[index]['Total']}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
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
                                            Icon(Icons.comment),
                                            Text(
                                              '  ${allRides[index]['Remarks']}',
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
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              'Offer Date:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              // DateTime.fromMillisecondsSinceEpoch(allRides[index]['Timestamp'] * 1000).toString()
                                              '  ${allRides[index]['Timestamp'].toDate().toString().substring(0, 10)}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        (allRides[index]['Date']
                                                    .toDate()
                                                    .compareTo(
                                                        DateTime.now()) >=
                                                -1)
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
                                                      'View Requests',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      // Utils.showSnackBar(
                                                      //     myRides[index].toString());
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              RequestsDetails(
                                                            rideId:
                                                                allRides[index]
                                                                    ['Ride ID'],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    width: 18,
                                                  ),
                                                  TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .blue[300]!),
                                                    ),
                                                    child: const Text(
                                                      'Cancel Ride',
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
                                                            // key: formKey,
                                                            title: const Text(
                                                                'Cancel Ride'),
                                                            content: const Text(
                                                                'Are you sure you want to cancel this ride?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'No'),
                                                              ),
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();

                                                                  // remove all joined
                                                                  var riderCol = await _firestore
                                                                      .collection(
                                                                          'Rides')
                                                                      .where(
                                                                          'Offer ID',
                                                                          isEqualTo:
                                                                              allRides[index]['Ride ID'])
                                                                      .get();
                                                                  for (var rider
                                                                      in riderCol
                                                                          .docs) {
                                                                    await rider
                                                                        .reference
                                                                        .delete();
                                                                  }

                                                                  // remove all requests
                                                                  var requestCol = await _firestore
                                                                      .collection(
                                                                          'Requests')
                                                                      .where(
                                                                          'Ride ID',
                                                                          isEqualTo:
                                                                              allRides[index]['Ride ID'])
                                                                      .get();
                                                                  for (var request
                                                                      in requestCol
                                                                          .docs) {
                                                                    await request
                                                                        .reference
                                                                        .delete();
                                                                  }

                                                                  // remove offering
                                                                  await _firestore
                                                                      .collection(
                                                                          'Offer')
                                                                      .doc(allRides[
                                                                              index]
                                                                          [
                                                                          'Ride ID'])
                                                                      .delete();

                                                                  // ignore: use_build_context_synchronously
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Yes'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    width: 18,
                                                  ),
                                                  TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .blue[300]!),
                                                    ),
                                                    child: const Text(
                                                      'Edit Remarks',
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
                                                                  'Edit Remarks'),
                                                              content: Form(
                                                                key: formKey,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                          child:
                                                                              Container(
                                                                    height: 100,
                                                                    child: Column(
                                                                        children: [
                                                                          TextField(
                                                                            // onChanged: (value) => updateSrc(value),
                                                                            controller:
                                                                                remarksController,
                                                                            cursorColor:
                                                                                Colors.black,
                                                                            textInputAction:
                                                                                TextInputAction.next,
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              labelText: 'Remarks',
                                                                              border: OutlineInputBorder(),
                                                                              prefixIcon: Icon(Icons.comment),
                                                                            ),
                                                                          ),
                                                                        ]),
                                                                  )),
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'No'),
                                                                ),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      // edit remarks in firestore offered collection
                                                                      _firestore
                                                                          .collection(
                                                                              'Offer')
                                                                          .doc(allRides[index]
                                                                              [
                                                                              'Ride ID'])
                                                                          .update({
                                                                        'Remarks':
                                                                            remarksController.text
                                                                      });
                                                                      Utils.showSnackBar(
                                                                          'Remarks Edited');
                                                                    },
                                                                    child: const Text(
                                                                        'Yes')),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                  ),
                                                ],
                                              )
                                            : Row(
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
                                                      'Edit Remarks',
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
                                                                  'Edit Remarks'),
                                                              content: Form(
                                                                key: formKey,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                          child:
                                                                              Container(
                                                                    height: 100,
                                                                    child: Column(
                                                                        children: [
                                                                          TextFormField(
                                                                            // onChanged: (value) => updateSrc(value),
                                                                            controller:
                                                                                remarksController,
                                                                            cursorColor:
                                                                                Colors.black,
                                                                            textInputAction:
                                                                                TextInputAction.next,
                                                                            autovalidateMode:
                                                                                AutovalidateMode.onUserInteraction,
                                                                            validator: (e) => e == null
                                                                                ? 'Enter any remarks such as price distribution, etc.'
                                                                                : (e.length > 40)
                                                                                    ? 'Remarks should be less than 40 characters'
                                                                                    : null,
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              labelText: 'Remarks',
                                                                              border: OutlineInputBorder(),
                                                                              prefixIcon: Icon(Icons.comment),
                                                                            ),
                                                                          ),
                                                                        ]),
                                                                  )),
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'No'),
                                                                ),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      // edit remarks in firestore offered collection
                                                                      _firestore
                                                                          .collection(
                                                                              'Offer')
                                                                          .doc(allRides[index]
                                                                              [
                                                                              'Ride ID'])
                                                                          .update({
                                                                        'Remarks':
                                                                            remarksController.text
                                                                      });
                                                                      Utils.showSnackBar(
                                                                          'Remarks Edited');
                                                                    },
                                                                    child: const Text(
                                                                        'Yes')),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                  ),
                                                ],
                                              ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        //   ListTile(
                                        //     title: Column(
                                        //       children: [
                                        //         SizedBox(
                                        //           width: 8,
                                        //         ),
                                        //         Icon(Icons.directions_car),
                                        //         Text(
                                        //           '  ${allRides[index]['Car Type']}',
                                        //           style: const TextStyle(
                                        //               fontSize: 16,
                                        //               fontWeight: FontWeight.bold),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //     trailing: Column(
                                        //       children: [
                                        //         SizedBox(
                                        //           width: 8,
                                        //         ),
                                        //         Icon(Icons.person),
                                        //         Text(
                                        //           '  ${allRides[index]['Available']}',
                                        //           style: const TextStyle(
                                        //               fontSize: 16,
                                        //               fontWeight: FontWeight.bold),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   Row(
                                        //     children: [
                                        //       SizedBox(
                                        //         width: 8,
                                        //       ),
                                        //       Icon(Icons.directions_car),
                                        //       Text(
                                        //         '  ${allRides[index]['Car Type']}',
                                        //         style: const TextStyle(
                                        //             fontSize: 16,
                                        //             fontWeight: FontWeight.bold),
                                        //       ),
                                        //     ],
                                        //   ),
                                        //   const SizedBox(
                                        //     height: 8,
                                        //   ),
                                        //   Row(
                                        //     children: [
                                        //       SizedBox(
                                        //         width: 8,
                                        //       ),
                                        //       Icon(Icons.person),
                                        //       Text(
                                        //         '  ${allRides[index]['Available']}',
                                        //         style: const TextStyle(
                                        //             fontSize: 16,
                                        //             fontWeight: FontWeight.bold),
                                        //       ),
                                        //     ],
                                        //   ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    )),
        ],

        // bottomNavigationBar: BottomAppBar(
        //   child: Text(
        //     'Tap to get passenger details...',
        //     textAlign: TextAlign.right,
        //   ),
        // ),
      ),
    );
  }

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  int dateCheck = 0;
  var chosenDate = "NOT SET";
  // RestorableDateTime(DateTime(2023, 1, 1));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime.now(),
          lastDate: DateTime(2024),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        dateCheck = 1;
        chosenDate =
            formatDate(_selectedDate.value.toString().substring(0, 10));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  void showFilterDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget clearFilterButton = TextButton(
      onPressed: () {
        setState(() {
          allRides = allOriginalRides;
        });
        Navigator.pop(context);
      },
      child: const Text('Clear'),
    );

    TextEditingController _sourceController = TextEditingController();
    TextEditingController _destinationController = TextEditingController();

    Widget filterButton = TextButton(
        onPressed: () {
          String src = _sourceController.text.trim();
          String dst = _destinationController.text.trim();
          setState(() {
            allRides = allOriginalRides;
            if (src.isNotEmpty) {
              allRides = allRides
                  .where((element) => element['Source']
                      .toString()
                      .toLowerCase()
                      .contains(src.toLowerCase()))
                  .toList();
            }
            if (dst.isNotEmpty) {
              allRides = allRides
                  .where((element) => element['Destination']
                      .toString()
                      .toLowerCase()
                      .contains(dst.toLowerCase()))
                  .toList();
            }
            if (dateCheck == 1) {
              allRides = allRides
                  .where((element) =>
                      element['Date'].toDate().toString().split(' ')[0] ==
                      _selectedDate.value.toString().split(' ')[0])
                  .toList();
            }
          });
          Navigator.pop(context);
        },
        child: const Text('Apply'));

    AlertDialog filter = AlertDialog(
      title: const Text('Filter'),
      content: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Container(
              height: 300,
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    // onChanged: (value) => updateSrc(value),
                    controller: _sourceController,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Source',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    // onChanged: (value) => updateDst(value),
                    controller: _destinationController,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Destination',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                      // backgroundColor: Colors.black12,
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[100]),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                      // borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: () => _restorableDatePickerRouteFuture.present(),
                    // child: (chosenDate != "NOT SET")
                    //     ? Text(
                    //         chosenDate,
                    //         style: const TextStyle(
                    //           color: Colors.black87,
                    //           fontSize: 21,
                    //           // decoration: TextDecoration.underline,
                    //         ),
                    //       )
                    //     :
                    child: const Text(
                      'Select Date',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 21,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          )),
      actions: [
        cancelButton,
        clearFilterButton,
        filterButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return filter;
      },
    );
  }

  @override
  // TODO: implement restorationId
  String? get restorationId => widget.restorationId;
}
