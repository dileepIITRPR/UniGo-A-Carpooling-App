import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function buttonClicked;
  const CustomButton(
      {super.key, required this.buttonText, required this.buttonClicked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 20,
      ),
      child: Center(
        child: Container(
          height: 42,
          width: 180,
          decoration: BoxDecoration(
              color: Colors.blue[300], borderRadius: BorderRadius.circular(12)),
          child: TextButton(
            onPressed: () {
              buttonClicked();
            },
            child: Text(
              buttonText,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 21,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
