import 'package:cloud_firestore/cloud_firestore.dart';

class PoolModel {
  final String? id;
  final String src;
  final String dst;
  final String email;
  final DateTime date;
  final String passenger;
  final String cartype;
  final String name;
  final String gender;
  final String type;
  final String dept;

  PoolModel(
      {this.id,
      required this.src,
      required this.dst,
      required this.date,
      required this.passenger,
      required this.cartype,
      required this.email,
      required this.name,
      required this.gender,
      required this.type,
      required this.dept});

  toJson() {
    return {
      "Available": passenger,
      "Car Type": cartype,
      "Date": date,
      "Source": src,
      "Destination": dst,
      "Email": email,
      "Name": name,
      "Gender": gender,
      "Type": type,
      "Department": dept,
    };
  }

  // factory PoolModel.fromSnapshot(Map<String, dynamic> data) {
  //   return PoolModel(
  //     passenger: data["Available"],
  //     email: data["Email"],
  //     src: data["Source"],
  //     dst: data["Destination"],
  //     cartype: data["Car type"],
  //     date: data["Date"],
  //   );
  // }
}
