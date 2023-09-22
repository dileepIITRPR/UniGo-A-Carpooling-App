import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final bool obscureText;
  final String labelText;
  // final IconButton suffixIcon;
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.textInputAction,
      required this.obscureText,
      required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      textInputAction: textInputAction,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        // suffixIcon: ,
      ),
    );
  }
}
