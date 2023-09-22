import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String entry_num;
  String email;
  String phone;
  String type;
  String dept;
  String gender;
  String password;

  UserModel(
      {required this.name,
      required this.entry_num,
      required this.email,
      required this.phone,
      required this.type,
      required this.dept,
      required this.gender,
      required this.password});

  toJson() {
    return {
      'Name': name,
      'Entry_Num': entry_num,
      'Email': email,
      'Phone': phone,
      'Type': type,
      'Department': dept,
      'Gender': gender,
      'Password': password,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return UserModel(
        name: data!['Name'],
        entry_num: data['Entry Number'],
        email: data["Email"],
        phone: data['Phone'],
        type: data['Type'],
        dept: data['Department'],
        gender: data['Gender'],
        password: data["Password"]);
  }
}
