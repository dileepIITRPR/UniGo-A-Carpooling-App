import 'package:carpool/component/button.dart';
import 'package:carpool/models/pool_model.dart';
import 'package:carpool/utility/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});
  final String restorationId = "main";
  @override
  State<JoinPage> createState() => _JoinPageState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var user = FirebaseAuth.instance.currentUser!;

Future<bool> checkJoinedRequested(String docId) async {
  user = FirebaseAuth.instance.currentUser!;
  var idCollection =
      _firestore.collection('Rides').where('Offer ID', isEqualTo: docId);
  var idQuerySnapshot = await idCollection.get();

  for (var check in idQuerySnapshot.docs) {
    Map<String, dynamic> data = check.data();
    if (data['Email'] != null && data['Email'] == user.email!) {
      return Future<bool>.value(true);
    }
  }

  // already requested - maybe rejected or pending or accepted
  var requestCollection = _firestore
      .collection('Requests')
      .where('Ride ID', isEqualTo: docId)
      .where('Joiner', isEqualTo: user.email);
  var requestQuerySnapshot = await requestCollection.get();
  for (var check in requestQuerySnapshot.docs) {
    return Future<bool>.value(true);
  }

  return Future<bool>.value(false);
}

Future<String> getUserEmail(String docId) async {
  var userCollection = _firestore.collection('Offer').doc(docId);
  var userQuerySnapshot = await userCollection.get();
  Map<String, dynamic> data = userQuerySnapshot.data()!;
  return data['Email'].toString();
}

Future getUserDetails(String email) async {
  var userCollection =
      _firestore.collection('User').where('Email', isEqualTo: email);
  var userQuerySnapshot = await userCollection.get();
  Map<String, dynamic> data = userQuerySnapshot.docs[0].data();
  return data;
}

// List<String> docId = [];
// List<String> userEmail = [];
// List userDetail = [];

Future<List> getDocId() async {
  user = FirebaseAuth.instance.currentUser!;
  List<String> docId = [];
  var offerCollection = _firestore.collection('Offer');
  var offerQuerySnapshot = await offerCollection.get();
  for (var doc in offerQuerySnapshot.docs) {
    Map<String, dynamic> data = doc.data();
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);

    String idDoc = doc.id;
    bool joined = false;
    await checkJoinedRequested(idDoc).then((value) {
      joined = value;
    });

    if ((data['Email'] != user.email!) &&
        (date.compareTo(data['Date'].toDate()) <= 0) &&
        (joined == false) &&
        (data['Available'] != "0")) {
      docId.add(doc.id);
      // userEmail.add(await getUserEmail(doc.id));
      // String userEmail = await getUserEmail(doc.id);
      // userDetail.add(await getUserDetails(userEmail));
      // offersList.add(data);
    }
  }
  return docId;
}

Future<List> getOffers() async {
  user = FirebaseAuth.instance.currentUser!;
  List<dynamic> offersList = [];
  var offerCollection = _firestore.collection('Offer');
  var offerQuerySnapshot = await offerCollection.get();
  int len = offerQuerySnapshot.size;
  for (var doc in offerQuerySnapshot.docs) {
    Map<String, dynamic> data = doc.data();
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);

    String idDoc = doc.id;
    bool joined = false;
    await checkJoinedRequested(idDoc).then((value) {
      joined = value;
    });

    if ((data['Email'] != user.email!) &&
        (date.compareTo(data['Date'].toDate()) <= 0) &&
        (joined == false) &&
        (data['Available'] != "0")) {
      // docId.add(doc.id);
      // userEmail.add(await getUserEmail(doc.id));
      // userDetail.add(await getUserDetails(userEmail));
      String userEmail = await getUserEmail(doc.id);
      // debugPrint(userEmail);
      var userCollection =
          _firestore.collection('User').where('Email', isEqualTo: userEmail);
      var userQuerySnapshot = await userCollection.get();
      // debugPrint(userQuerySnapshot.docs.length.toString());
      Map<String, dynamic> userData = userQuerySnapshot.docs[0].data();

      data['Name'] = userData['Name'];
      data['Phone'] = userData['Phone'];
      data['Gender'] = userData['Gender'];
      data['Type'] = userData['Type'];
      data['Department'] = userData['Department'];
      data['Ride ID'] = doc.id;
      offersList.add(data);
    }
  }
  return offersList;
}

Future<List> getUserDetail() async {
  user = FirebaseAuth.instance.currentUser!;
  List userDetail = [];
  var offerCollection = _firestore.collection('Offer');
  var offerQuerySnapshot = await offerCollection.get();
  for (var doc in offerQuerySnapshot.docs) {
    Map<String, dynamic> data = doc.data();
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);

    String idDoc = doc.id;
    bool joined = false;
    await checkJoinedRequested(idDoc).then((value) {
      joined = value;
    });

    if ((data['Email'] != user.email!) &&
        (date.compareTo(data['Date'].toDate()) <= 0) &&
        (joined == false) &&
        (data['Available'] != "0")) {
      // docId.add(doc.id);
      // userEmail.add(await getUserEmail(doc.id));
      String userEmail = await getUserEmail(doc.id);
      userDetail.add(await getUserDetails(userEmail));
      // offersList.add(data);
    }
  }
  return userDetail;
}

class _JoinPageState extends State<JoinPage> with RestorationMixin {
  List<dynamic> offers = [];
  List<dynamic> allOffers = [];
  // List<dynamic> docId = [];
  // List userDetail = [];
  final formKey = GlobalKey<FormState>();
  final srcController = TextEditingController();
  final dstController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      user = FirebaseAuth.instance.currentUser!;
    });
    _isLoading = true;

    dateCheck = 0;
    // getDocId().then((List val) {
    //   setState(() {
    //     docId = List.from(val);
    //   });
    // });

    getOffers().then((List val) {
      setState(() {
        offers = List.from(val);
        offers.sort((a, b) => b['Date'].compareTo(a['Date']));
        allOffers = List.from(val);
        allOffers.sort((a, b) => b['Date'].compareTo(a['Date']));
      });
    });
    // getUserDetail().then((List val) {
    //   setState(() {
    //     userDetail = val;
    //   });
    // });
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
  void dispose() {
    srcController.dispose();
    dstController.dispose();

    super.dispose();
  }

  void updateSrc(String src) {
    setState(() {
      offers = allOffers
          .where((element) => element['Source']
              .toString()
              .toLowerCase()
              .contains(src.toLowerCase()))
          .toList();

      if (dstController.text.trim().isNotEmpty) {
        offers = offers
            .where((element) => element['Destination']
                .toString()
                .toLowerCase()
                .contains(dstController.text.trim().toLowerCase()))
            .toList();
      }
    });
  }

  void updateDst(String dst) {
    setState(() {
      offers = allOffers
          .where((element) => element['Destination']
              .toString()
              .toLowerCase()
              .contains(dst.toLowerCase()))
          .toList();

      if (srcController.text.trim().isNotEmpty) {
        offers = offers
            .where((element) => element['Source']
                .toString()
                .toLowerCase()
                .contains(srcController.text.trim().toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        ),
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
          // Form(
          //   key: formKey,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Column(
          //       children: [
          //         const SizedBox(
          //           height: 8,
          //         ),
          //         TextField(
          //           onChanged: (value) => updateSrc(value),
          //           controller: srcController,
          //           cursorColor: Colors.black,
          //           textInputAction: TextInputAction.next,
          //           decoration: const InputDecoration(
          //             labelText: 'Source',
          //             border: OutlineInputBorder(),
          //             prefixIcon: Icon(Icons.location_on),
          //           ),
          //         ),
          //         const SizedBox(
          //           height: 8,
          //         ),
          //         TextField(
          //           onChanged: (value) => updateDst(value),
          //           controller: dstController,
          //           cursorColor: Colors.black,
          //           textInputAction: TextInputAction.done,
          //           decoration: const InputDecoration(
          //             labelText: 'Destination',
          //             border: OutlineInputBorder(),
          //             prefixIcon: Icon(Icons.location_on),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          const SizedBox(
            height: 4,
          ),
          _isLoading == true
              ? Column(
                  children: const [
                    SizedBox(
                      height: 12,
                    ),
                    Center(child: CircularProgressIndicator()),
                  ],
                )
              : (offers.isEmpty
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
                            'No carpools currently \navailable for joining. ',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: () {
                          // Navigator.pushReplacement<void, void>(
                          //   context,
                          //   MaterialPageRoute<void>(
                          //     builder: (BuildContext context) => const JoinPage(),
                          //   ),
                          // );
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        JoinPage(),
                                transitionDuration: Duration(seconds: 0),
                              ));
                          return Future.value(false);
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: offers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              alignment: Alignment.topLeft,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                // boxShadow: [
                                //   BoxShadow(spreadRadius: 0.5, color: Colors.white)
                                // ],
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          //set border radius more than 50% of height and width to make circle
                                        ),
                                        borderOnForeground: true,
                                        color: Colors.white,
                                        elevation: 32,
                                        shadowColor: Colors.blue,
                                        child: InkWell(
                                          onTap: () {
                                            showAlertDialog(context, index);
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.all(8),
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue[100],
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  12),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  12),
                                                        ),
                                                        border: Border.all(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      child: Text(
                                                          '${offers[index]['Source']}'),
                                                    ),
                                                  ),
                                                  Icon(Icons.arrow_forward),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.all(8),
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      // height: 20,
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue[100],
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topRight:
                                                              Radius.circular(
                                                                  12),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  12),
                                                        ),
                                                        border: Border.all(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        '${offers[index]['Destination']}',
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
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Icon(Icons.date_range),
                                                      Text(
                                                        '  ${formatDate(offers[index]['Date'].toDate().toString().split(' ')[0])}',
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
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
                                                      Icon(Icons.timer),
                                                      Text(
                                                        offers[index]['Time']
                                                                    .toString()
                                                                    .isEmpty ==
                                                                true
                                                            ? ''
                                                            : '  ${offers[index]['Time'].toString().substring(0, 5)}',
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
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
                                                      Icon(
                                                          Icons.directions_car),
                                                      Text(
                                                        '  ${offers[index]['Car Type']}',
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
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
                                                        '  ${int.parse(offers[index]['Total']) - int.parse(offers[index]['Available'])} / ${offers[index]['Total']}',
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Icon(Icons.person),
                                                  Text(
                                                    '  ${offers[index]['Name']}',
                                                    // '  ${userDetail[index]['Name']}',
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
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Icon(Icons.email),
                                                  Text(
                                                    '  ${offers[index]['Email']}',
                                                    // '  ${userDetail[index]['Email']}',
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
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Icon(Icons.location_city),
                                                  Text(
                                                    '  ${offers[index]['Type']} (${offers[index]['Department']})',
                                                    // '  ${userDetail[index]['Type']} (${userDetail[index]['Department']})',
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
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Icon(Icons.flag),
                                                  Text(
                                                    '  ${offers[index]['Gender']}',
                                                    // '  ${userDetail[index]['Gender']}',
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
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Icon(Icons.comment),
                                                  Text(
                                                    '  ${offers[index]['Remarks']}',
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
                          },
                        ),
                      ),
                    )),
        ],
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Text(
      //     'Tap to join ride...',
      //     textAlign: TextAlign.right,
      //   ),
      // ),
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
          offers = allOffers;
          chosenDate = "NOT SET";
        });
        Navigator.pop(context);
      },
      child: const Text('Clear'),
    );

    TextEditingController _sourceController = TextEditingController();
    TextEditingController _destinationController = TextEditingController();
    const List<String> gender = <String>['Any', 'Female', 'Male'];
    String genderT = 'Any';
    const List<String> userT = <String>['Any', 'Student', 'Faculty', 'Staff'];
    String userType = 'Any';
    const List<String> typeC = <String>[
      'Any',
      'Self Drive',
      'Taxi',
      'Auto Rickshaw'
    ];
    String typeCr = 'Any';

    Widget filterButton = TextButton(
      child: const Text("Apply"),
      onPressed: () {
        String src = _sourceController.text.trim();
        String dst = _destinationController.text.trim();
        setState(() {
          offers = allOffers;
          if (src.isNotEmpty) {
            offers = offers
                .where((element) => element['Source']
                    .toString()
                    .toLowerCase()
                    .contains(src.toLowerCase()))
                .toList();
          }
          if (dst.isNotEmpty) {
            offers = offers
                .where((element) => element['Destination']
                    .toString()
                    .toLowerCase()
                    .contains(dst.toLowerCase()))
                .toList();
          }
          if (genderT != 'Any') {
            offers = offers
                .where((element) => element['Gender'].toString() == genderT)
                .toList();
          }
          if (userType != 'Any') {
            offers = offers
                .where((element) => element['Type'].toString() == userType)
                .toList();
          }
          if (typeCr != 'Any') {
            offers = offers
                .where((element) => element['Car Type'].toString() == typeCr)
                .toList();
          }
          if (dateCheck == 1) {
            offers = offers
                .where((element) =>
                    element['Date'].toDate().toString().split(' ')[0] ==
                    _selectedDate.value.toString().split(' ')[0])
                .toList();
          }
        });

        Navigator.pop(context);
      },
    );

    AlertDialog filter = AlertDialog(
      title: const Text("Filter"),
      content: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Container(
              height: 370,
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
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          'Gender -  ',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      StatefulBuilder(builder: ((context, setState) {
                        return DropdownButton<String>(
                            // RADIO BUTTON
                            items: gender
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }).toList(),
                            value: genderT,
                            onChanged: (String? value) {
                              setState(() {
                                genderT = value!;
                              });
                            });
                      })),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          'User Type -  ',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      StatefulBuilder(builder: (context, setState) {
                        return DropdownButton<String>(
                            // RADIO BUTTON
                            items: userT
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }).toList(),
                            value: userType,
                            onChanged: (String? value) {
                              setState(() {
                                userType = value!;
                              });
                            });
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          'Car Type -  ',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      StatefulBuilder(
                        builder: ((context, setState) {
                          return DropdownButton<String>(
                              // RADIO BUTTON
                              items: typeC.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }).toList(),
                              value: typeCr,
                              onChanged: (String? value) {
                                setState(() {
                                  typeCr = value!;
                                });
                              });
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return OutlinedButton(
                        style: ButtonStyle(
                          // backgroundColor: Colors.black12,
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue[100]),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0))),
                          // borderRadius: BorderRadius.circular(12),
                        ),
                        onPressed: () =>
                            _restorableDatePickerRouteFuture.present(),
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
                      );
                    },
                    // child: OutlinedButton(
                    //   style: ButtonStyle(
                    //     // backgroundColor: Colors.black12,
                    //     backgroundColor:
                    //         MaterialStateProperty.all(Colors.blue[100]),
                    //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(8.0))),
                    //     // borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   onPressed: () => _restorableDatePickerRouteFuture.present(),
                    //   child: (chosenDate != "NOT SET")
                    //       ? Text(
                    //           chosenDate,
                    //           style: const TextStyle(
                    //             color: Colors.black87,
                    //             fontSize: 21,
                    //             // decoration: TextDecoration.underline,
                    //           ),
                    //         )
                    //       : const Text(
                    //           'Select Date',
                    //           style: TextStyle(
                    //             color: Colors.black87,
                    //             fontSize: 21,
                    //             // decoration: TextDecoration.underline,
                    //           ),
                    //         ),
                    // ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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

  void showAlertDialog(BuildContext context, int index) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // Widget continueButton = TextButton(
    //   child: const Text("Continue"),
    //   onPressed: () async {
    //     await _firestore
    //         .collection('Rides')
    //         .doc()
    //         .set({'Offer ID': docId[index], 'Email': user.email!});
    //     int seats = int.parse(offers[index]['Available']);
    //     seats--;
    //     offers[index]['Available'] = seats.toString();

    //     await _firestore
    //         .collection('Offer')
    //         .doc(docId[index])
    //         .set(offers[index]);
    //     Navigator.pop(context);
    //     Navigator.pop(context);
    //     Utils.showSnackBar('Ride Joined!!!');
    //   },
    // );

    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () async {
        await _firestore.collection('Requests').doc().set({
          'Ride ID': offers[index]['Ride ID'],
          'Joiner': user.email!,
          'Offeror': offers[index]['Email'],
          'Status': 'Pending'
        });
        // int seats = int.parse(offers[index]['Available']);
        // seats--;
        // offers[index]['Available'] = seats.toString();

        // await _firestore
        //     .collection('Offer')
        //     .doc(docId[index])
        //     .set(offers[index]);
        Navigator.pop(context);
        Navigator.pop(context);
        Utils.showSnackBar('Ride Requested!');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Join ride?"),
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
        return alert;
      },
    );
  }

  @override
  // TODO: implement restorationId
  String? get restorationId => widget.restorationId;
}
