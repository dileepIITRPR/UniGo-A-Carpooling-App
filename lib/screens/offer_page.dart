import 'package:carpool/utility/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../component/button.dart';
import 'package:flutter/material.dart';

class OfferPage extends StatefulWidget {
  const OfferPage({super.key});
  final String restorationId = "main";
  @override
  State<OfferPage> createState() => _OfferPageState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var user = FirebaseAuth.instance.currentUser!;

const List<String> list = <String>['Self Drive', 'Taxi', 'Auto Rickshaw'];

Future<List> getLocations() async {
  var locationCollection = await _firestore.collection('Location').get();
  List<dynamic> locations = [];
  for (var doc in locationCollection.docs) {
    locations.add(doc.data()['Name'].toString());
  }
  return locations;
}

class _OfferPageState extends State<OfferPage> with RestorationMixin {
  final formKey = GlobalKey<FormState>();
  final _gKey = GlobalKey();
  final srccontroller = TextEditingController();
  String source = '';
  String destination = '';
  final dstcontroller = TextEditingController();
  // final datecontroller = TextEditingController();
  final remarkscontroller = TextEditingController();
  final srcfn = FocusNode();
  final dstfn = FocusNode();
  var chosenDate = "NOT SET";

  TextEditingController timeinput = TextEditingController();

  String cartype = "Self Drive";
  int carIndex = 0;
  int numPass = 1;
  List<String> locations = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      user = FirebaseAuth.instance.currentUser!;
    });
    timeinput.text = "";
    getLocations().then((value) {
      setState(() {
        locations = List<String>.from((value));
        // for (var l in locations) {
        //   print(l);
        // }
      });
    });
  }

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
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
        chosenDate =
            formatDate(_selectedDate.value.toString().substring(0, 10));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final formatter = DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offer', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.blue[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Autocomplete<String>(
              //   optionsBuilder: (TextEditingValue tev) {
              //     return locations
              //         .where((element) => element
              //             .toString()
              //             .toLowerCase()
              //             .startsWith(tev.text.toLowerCase()))
              //         .toList();
              //   },
              //   displayStringForOption: (option) => option.toString(),
              //   fieldViewBuilder: (BuildContext context,
              //       TextEditingController fieldTextEditingController,
              //       FocusNode fieldFocusNode,
              //       VoidCallback onFieldSubmitted) {
              //     return TextField(
              //       controller: fieldTextEditingController,
              //       focusNode: fieldFocusNode,
              //       style: const TextStyle(fontWeight: FontWeight.bold),
              //     );
              //   },
              //   onSelected: (option) => print(option.toString()),
              //   optionsViewBuilder: ((context, onSelected, options) {
              //     return Align(
              //       alignment: Alignment.topLeft,
              //       child: Material(
              //         child: Container(
              //           width: 300,
              //           child: ListView.builder(
              //             itemCount: options.length,
              //             itemBuilder: ((context, index) {
              //               final option = options.elementAt(index);
              //               return GestureDetector(
              //                 onTap: () {
              //                   onSelected(option);
              //                 },
              //                 child: ListTile(
              //                   title: Text(option.toString()),
              //                 ),
              //               );
              //             }),
              //           ),
              //         ),
              //       ),
              //     );
              //   }),
              // ),
              const SizedBox(
                height: 16,
              ),
              RawAutocomplete(
                // key: formKey,
                textEditingController: srccontroller,
                focusNode: srcfn,
                optionsBuilder: (TextEditingValue tev) {
                  if (tev.text == '') {
                    return const Iterable<String>.empty();
                  } else {
                    List<String> matches = <String>[];
                    matches.addAll(locations);
                    matches.retainWhere((element) {
                      return element
                          .toLowerCase()
                          .contains(tev.text.toLowerCase());
                    });
                    return matches;
                  }
                },
                onSelected: (String selection) {
                  print('Selection: $selection');
                },
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  return TextField(
                    decoration: InputDecoration(
                      label: Container(
                        width: 66,
                        child: Row(children: const [
                          Text('Source '),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          )
                        ]),
                      ),
                      // labelText: 'Source *',
                      border: OutlineInputBorder(),
                    ),
                    controller: textEditingController,
                    focusNode: focusNode,
                    onSubmitted: ((value) {
                      setState(() {
                        source = value;
                        Utils.showSnackBar(source);
                      });
                    }),
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Material(
                    child: SizedBox(
                      height: 100,
                      child: SingleChildScrollView(
                          child: Column(
                        children: options.map((opt) {
                          return InkWell(
                            onTap: () {
                              onSelected(opt);
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 32),
                              child: Card(
                                margin: EdgeInsets.only(bottom: 4, top: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.black54,
                                      width: 1,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  width: double.infinity,
                                  child: Text(opt),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                    ),
                  );
                },
                // optionsViewBuilder: (BuildContext context, void Function(String) onSelected, Iterable<String> options) {  },
              ),
              const SizedBox(
                height: 16,
              ),
              RawAutocomplete(
                // key: formKey,
                textEditingController: dstcontroller,
                focusNode: dstfn,
                optionsBuilder: (TextEditingValue tev) {
                  if (tev.text == '') {
                    return const Iterable<String>.empty();
                  } else {
                    List<String> matches = <String>[];
                    matches.addAll(locations);
                    matches.retainWhere((element) {
                      return element
                          .toLowerCase()
                          .contains(tev.text.toLowerCase());
                    });
                    return matches;
                  }
                },
                onSelected: (String selection) {
                  print('Selection: $selection');
                },
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  return TextField(
                    decoration: InputDecoration(
                        label: Container(
                          width: 102,
                          child: Row(children: const [
                            Text('Destination '),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            )
                          ]),
                        ),
                        border: OutlineInputBorder()),
                    controller: textEditingController,
                    focusNode: focusNode,
                    onSubmitted: ((value) {
                      setState(() {
                        destination = value;
                        Utils.showSnackBar(destination);
                      });
                    }),
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Material(
                    child: SizedBox(
                      height: 200,
                      child: SingleChildScrollView(
                          child: Column(
                        children: options.map((opt) {
                          return InkWell(
                            onTap: () {
                              onSelected(opt);
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 32),
                              child: Card(
                                margin: EdgeInsets.only(bottom: 4, top: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.black54,
                                      width: 1,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  width: double.infinity,
                                  child: Text(opt),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                    ),
                  );
                },
                // optionsViewBuilder: (BuildContext context, void Function(String) onSelected, Iterable<String> options) {  },
              ),
              const SizedBox(height: 32),
              // TextFormField(
              //   controller: srccontroller,
              //   cursorColor: Colors.black,
              //   textInputAction: TextInputAction.next,
              //   decoration: const InputDecoration(
              //     labelText: 'Source *',
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (e) => e == null ? 'Enter Source Address' : null,
              // ),
              // const SizedBox(height: 16),
              // TextFormField(
              //   controller: dstcontroller,
              //   cursorColor: Colors.black,
              //   textInputAction: TextInputAction.next,
              //   decoration: const InputDecoration(
              //     labelText: 'Destination *',
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (e) =>
              //       e == null ? 'Enter Destination Address' : null,
              // ),
              // const SizedBox(height: 8),
              // TextFormField(
              //   controller: passengercontroller,
              //   cursorColor: Colors.black,
              //   textInputAction: TextInputAction.next,
              //   decoration: const InputDecoration(
              //     labelText: 'Number of Passengers (excluding yourself)',
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (e) => (e == null ||
              //           !RegExp(r'[a-zA-Z0-9]+')
              //               .hasMatch(passengercontroller.text.trim()))
              //       ? 'Enter total available seats excluding yourself'
              //       : null,
              // ),
              // const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(left: 31, right: 31),
                alignment: Alignment.center,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(5),
                //   border: Border.all(
                //     color: Colors.black38,
                //   ),

                // ),
                child: InputDecorator(
                  decoration: InputDecoration(
                    label: Container(
                      width: 129,
                      child: Row(children: const [
                        Text('Available Seats '),
                        Text(
                          '*',
                          style: TextStyle(color: Colors.red),
                        )
                      ]),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            if (numPass == 1) {
                              Utils.showSnackBar(
                                  'Minimum number of passengers is 1');
                            } else {
                              setState(() {
                                numPass--;
                              });
                            }
                          },
                          child: Icon(
                            Icons.remove,
                            color: Colors.black,
                            size: 16,
                          )),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        padding:
                            EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          // border: Border.all(color: Colors.black),
                          // color: Colors.white,
                        ),
                        child: Text(
                          numPass.toString(),
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          onTap: () {
                            setState(() {
                              numPass++;
                            });
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 16,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              // DropdownButton<String>(
              //     items: list.map<DropdownMenuItem<String>>((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(value),
              //       );
              //     }).toList(),
              //     value: cartype,
              //     onChanged: (String? value) {
              //       setState(() {
              //         cartype = value!;
              //       });
              //     }),
              // const SizedBox(height: 12),
              Wrap(
                spacing: 15.0,
                children: List<Widget>.generate(
                  3,
                  (int index) {
                    return ChoiceChip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        side: (carIndex == index)
                            ? BorderSide(color: Colors.black87)
                            : BorderSide(color: Colors.white),
                      ),
                      backgroundColor: Colors.blue[100],
                      // avatarBorder: ,

                      label: Text('${list.elementAt(index)}'),
                      selected: carIndex == index,
                      labelStyle: TextStyle(
                        // fontWeight: FontWeight.bold,
                        // backgroundColor: Colors.blue[100],
                        color:
                            (carIndex == index) ? Colors.black : Colors.black54,
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          carIndex = index;
                          cartype = list.elementAt(index);
                          Utils.showSnackBar(
                              '${list.elementAt(index)} selected!');
                        });
                      },
                    );
                  },
                ).toList(),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                style: ButtonStyle(
                  // backgroundColor: Colors.black12,
                  backgroundColor: MaterialStateProperty.all(Colors.blue[100]),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0))),
                  // borderRadius: BorderRadius.circular(12),
                ),
                onPressed: () => _restorableDatePickerRouteFuture.present(),
                child: Container(
                  width: 160,
                  child: chosenDate == "NOT SET"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Select Date ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                )),
                            Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 21,
                              ),
                            )
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(chosenDate,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                )),
                          ],
                        ),
                ),
              ),
              // const Text(
              //   'Select Date *',
              //   style: TextStyle(
              //     color: Colors.black87,
              //     fontSize: 21,
              //     // decoration: TextDecoration.underline,
              //   ),
              // ),

              const SizedBox(height: 20),
              TextField(
                key: _gKey,
                controller: timeinput,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    labelText: "Enter Time", border: OutlineInputBorder()),
                readOnly:
                    true, //set it true, so that user will not able to edit text
                onTap: () async {
                  showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  ).then((value) {
                    DateTime parsedTime = DateFormat.jm()
                        .parse(value!.format(context).toString());
                    // value?.format(context).toString();
                    //converting to DateTime so that we can further format on different pattern.
                    // print(parsedTime); //output 1970-01-01 22:53:00.000
                    String formattedTime =
                        DateFormat('HH:mm:ss').format(parsedTime);
                    // print(formattedTime); //output 14:59:00
                    //DateFormat() is from intl package, you can format the time on any pattern you need.

                    setState(() {
                      timeinput.text =
                          formattedTime; //set the value of text field.
                    });
                  });
                  // TimeOfDay? pickedTime = await showTimePicker(
                  //   initialTime: TimeOfDay.now(),
                  //   context: context,
                  // );

                  // if (pickedTime != null) {
                  //   // print(pickedTime.format(context)); //output 10:51 PM
                  //   DateTime parsedTime = DateFormat.jm()
                  //       .parse(pickedTime.format(context).toString());
                  //   //converting to DateTime so that we can further format on different pattern.
                  //   // print(parsedTime); //output 1970-01-01 22:53:00.000
                  //   String formattedTime =
                  //       DateFormat('HH:mm:ss').format(parsedTime);
                  //   // print(formattedTime); //output 14:59:00
                  //   //DateFormat() is from intl package, you can format the time on any pattern you need.

                  //   setState(() {
                  //     timeinput.text =
                  //         formattedTime; //set the value of text field.
                  //   });
                  // } else {
                  //   print("Time is not selected");
                  // }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: remarkscontroller,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Remarks',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (e) => e == null
                    ? 'Enter any remarks such as price distribution, etc.'
                    : (e.length > 40)
                        ? 'Remarks should be less than 40 characters'
                        : null,
              ),
              const SizedBox(height: 8),
              CustomButton(
                  buttonText: 'Offer',
                  buttonClicked: () {
                    showAlertDialog(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future offerCarpool() async {
    user = FirebaseAuth.instance.currentUser!;
    source = srccontroller.text.trim();
    destination = dstcontroller.text.trim();
    // check empty
    // if (srccontroller.text.trim().isEmpty ||
    //     dstcontroller.text.trim().isEmpty) {
    //   Utils.showSnackBar('Enter valid Source/Destination location');
    //   return;
    // }
    // Utils.showSnackBar(locations.contains(source).toString());
    // if (locations.contains(source) == false ||
    //     locations.contains(destination) == false) {
    //   // Utils.showSnackBar('Enter valid Source/Destination location');
    //   return;
    // }

    // if (numPass == 0) {
    //   Utils.showSnackBar('Enter valid number of passengers');
    //   return;
    // }

    var _chosenDate =
        formatDate(_selectedDate.value.toString().substring(0, 10));
    var _curDate = formatDate(DateTime.now().toString().substring(0, 10));

    String _chosenTime = timeinput.text.trim();
    // DateTime _curTime = DateFormat.jm().parse(DateTime.now().toString());
    String _forCurTime = DateFormat('HH:mm:ss').format(DateTime.now());
    // check if _chosenTime is before _forCurTime
    if (_chosenDate == _curDate &&
        _chosenTime != "" &&
        _chosenTime.compareTo(_forCurTime) <= 0) {
      Utils.showSnackBar('Enter valid Date and Time');
      return;
    }

    if (source == destination) {
      Utils.showSnackBar('Source and Destination location cannot be same');
      return;
    }

    if (srccontroller.text.trim() == "" || dstcontroller.text.trim() == "") {
      Utils.showSnackBar("Source or Destination field cannot be empty.");
      return;
    }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Navigator.pop(context);
    await _firestore.collection('Offer').doc().set({
      // 'Source': srccontroller.text.trim(),
      'Source': source,
      // 'Destination': dstcontroller.text.trim(),
      'Destination': destination,
      'Available': numPass.toString(),
      'Total': numPass.toString(),
      'Car Type': cartype,
      'Date': _selectedDate.value,
      'Time': timeinput.text.trim(),
      'Email': user.email!,
      'Remarks': remarkscontroller.text.trim(),
      'Timestamp': DateTime.now(),
    });

    Utils.showSnackBar("Carpool offered!!!");
    // Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  void showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text('Continue'),
      onPressed: () {
        offerCarpool();
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Offer ride?"),
      content: Container(
        height: 260,
        child: SingleChildScrollView(
          child: Column(
            children: const [
              Text(
                'Note: Make sure Source or Destination address are not empty.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  "\nDefault date will be selected as todays date if you don't choose by yourself.\nRemarks and time field is optional.\nTime range can be tentative and can be discussed with other users upon joining."),
            ],
          ),
        ),
      ),
      // content: Text(""),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: formKey.currentContext!,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  // TODO: implement restorationId
  String? get restorationId => widget.restorationId;
}
