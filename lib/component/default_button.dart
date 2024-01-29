import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  DefaultButton({required this.label, this.onTap, this.buttonColor});

  VoidCallback? onTap;
  String label;
  Color? buttonColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(25)),
        width: 360,
        height: 50,
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
