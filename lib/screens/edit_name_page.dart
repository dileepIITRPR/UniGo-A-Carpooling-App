import 'package:carpool/component/button.dart';
import 'package:carpool/component/loading.dart';
import 'package:carpool/utility/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditName extends StatefulWidget {
  EditName({Key? key}) : super(key: key);

  @override
  State<EditName> createState() => _EditNameState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var user = FirebaseAuth.instance.currentUser!;

class _EditNameState extends State<EditName> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
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
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Name', style: TextStyle(color: Colors.black87)),
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
                controller: nameController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (name) => name!.isEmpty
                    ? 'Enter name'
                    : (RegExp(r'[a-zA-Z]').hasMatch(name))
                        ? null
                        : 'Enter valid name',
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
                              .update({'Name': nameController.text});
                          Utils.showSnackBar('Name updated');
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          // Navigator.pop(context);
                        }
                        // setState(() {
                        //   _loading = false;
                        // });
                      },
                      buttonText: 'Save Name',
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
