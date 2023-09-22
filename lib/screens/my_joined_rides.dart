import 'package:carpool/component/button.dart';
import 'package:carpool/screens/ride_details_page.dart';
import 'package:carpool/utility/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class MyJoinedRides extends StatefulWidget {
  const MyJoinedRides({super.key});
  final String restorationId = "main";
  @override
  State<MyJoinedRides> createState() => _MyJoinedRidesState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var user = FirebaseAuth.instance.currentUser!;

Future<List> getRides() async {
  user = FirebaseAuth.instance.currentUser!;
  List<dynamic> ridesList = [];
  var rideCollection =
      _firestore.collection('Rides').where('Email', isEqualTo: user.email!);
  var rideQuerySnapshot = await rideCollection.get();
  for (var doc in rideQuerySnapshot.docs) {
    Map<String, dynamic> data = doc.data();
    ridesList.add(data['Offer ID']);
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

class _MyJoinedRidesState extends State<MyJoinedRides> with RestorationMixin {
  final formKey = GlobalKey<FormState>();
  List<dynamic> myRides = [];
  List<dynamic> allRides = [];
  List<dynamic> allOriginalRides = [];
  bool _isLoading = false;

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
            allOriginalRides = allRides;
            allOriginalRides.sort((a, b) => b['Date'].compareTo(a['Date']));
          });
        });
      });
    });
    Future.delayed(const Duration(seconds: 2), () {
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
          'My Joined Rides',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
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
                          child: Text('No rides joined by you.'),
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
                                                    '${allRides[index]['Source']}'),
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
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Icon(Icons.date_range),
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
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Icon(Icons.directions_car),
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
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Icon(Icons.people),
                                                Text(
                                                  '  ${int.parse(allRides[index]['Total']) - int.parse(allRides[index]['Available'])} / ${allRides[index]['Total']}',
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
                                        (allRides[index]['Date']
                                                    .toDate()
                                                    .compareTo(
                                                        DateTime.now()) >=
                                                0)
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
                                                                .all<Color>(
                                                                    Colors.blue[
                                                                        300]!),
                                                      ),
                                                      child: const Text(
                                                        'Leave Ride',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Leave Ride'),
                                                                content: const Text(
                                                                    'Are you sure you want to leave this ride?'),
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
                                                                        () async {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      var offerCollection = await _firestore
                                                                          .collection(
                                                                              'Offer')
                                                                          .doc(allRides[index]
                                                                              [
                                                                              'Ride ID'])
                                                                          .get();
                                                                      var offerData =
                                                                          offerCollection
                                                                              .data();

                                                                      // check date
                                                                      Timestamp
                                                                          dateRide =
                                                                          offerData![
                                                                              'Date'];
                                                                      DateTime
                                                                          date =
                                                                          dateRide
                                                                              .toDate();
                                                                      // .toString()
                                                                      // .split(' ')[0];
                                                                      DateTime
                                                                          today =
                                                                          DateTime
                                                                              .now();
                                                                      // var todayDate =
                                                                      //     '${today.year}-${today.month}-${today.day}';
                                                                      if (date.compareTo(
                                                                              today) <
                                                                          0) {
                                                                        Utils.showSnackBar(
                                                                            'You cannot leave the ride that has already passed.');
                                                                      } else {
                                                                        // seats increase
                                                                        int seats =
                                                                            int.parse(offerData['Available']);
                                                                        seats++;
                                                                        offerData['Available'] =
                                                                            seats.toString();
                                                                        await _firestore
                                                                            .collection('Offer')
                                                                            .doc(allRides[index]['Ride ID'])
                                                                            .set(offerData);

                                                                        // remove from Rides
                                                                        var remRide = await _firestore
                                                                            .collection(
                                                                                'Rides')
                                                                            .where('Offer ID',
                                                                                isEqualTo: allRides[index]['Ride ID'])
                                                                            .where('Email', isEqualTo: user.email!)
                                                                            .get();
                                                                        await remRide
                                                                            .docs
                                                                            .first
                                                                            .reference
                                                                            .delete();

                                                                        // change status in requests to left
                                                                        _firestore
                                                                            .collection(
                                                                                'Requests')
                                                                            .where('Ride ID',
                                                                                isEqualTo: allRides[index]['Ride ID'])
                                                                            .where('Joiner', isEqualTo: user.email)
                                                                            .get()
                                                                            .then((value) async {
                                                                          value
                                                                              .docs
                                                                              .first
                                                                              .reference
                                                                              .update({
                                                                            'Status':
                                                                                'Leave'
                                                                          });
                                                                        });

                                                                        // Navigator.pop(context);
                                                                        // Navigator.pop(context);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      }
                                                                    },
                                                                    child: const Text(
                                                                        'Yes'),
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      }),
                                                ],
                                              )
                                            : Row(),
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
