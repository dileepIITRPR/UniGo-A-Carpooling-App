import 'package:carpool/component/button.dart';
import 'package:carpool/component/loading.dart';
import 'package:carpool/utility/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditPhone extends StatefulWidget {
  const EditPhone({super.key});

  @override
  State<EditPhone> createState() => _EditPhoneState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var user = FirebaseAuth.instance.currentUser!;

class _EditPhoneState extends State<EditPhone> {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    _loading = false;
    setState(() {
      user = FirebaseAuth.instance.currentUser!;
    });
  }

  @override
  void dispose() {
    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Edit Phone Number', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.blue[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 18,
          right: 18,
          top: 48,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: phoneController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (phone) =>
                    (phone != null && !RegExp(r'[0-9]{10}').hasMatch(phone))
                        ? 'Enter a valid phone number'
                        : null,
              ),
              const SizedBox(
                height: 8,
              ),
              _loading == true
                  ? const CustomLoading()
                  : CustomButton(
                      buttonClicked: () async {
                        // setState(() {
                        //   _loading = true;
                        // });
                        if (formKey.currentState!.validate()) {
                          await _firestore
                              .collection('User')
                              .doc(user.email!)
                              .update({'Phone': phoneController.text});
                          Utils.showSnackBar('Phone number updated');
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          // Navigator.pop(context);
                        }
                        // setState(() {
                        //   _loading = false;
                        // });
                      },
                      buttonText: 'Save Phone',
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
