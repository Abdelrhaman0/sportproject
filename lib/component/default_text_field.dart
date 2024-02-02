import 'package:flutter/material.dart';
import 'package:sports_project/component/conest.dart';

class DefaultTextFormField extends StatelessWidget {
  DefaultTextFormField({this.hintText, this.onChange, this.prefixIcon, this.suffixIcon, this.controller});

  Function(String)? onChange;
  String? hintText;
  Icon? prefixIcon;
  IconButton ? suffixIcon;
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      controller: controller,
      onChanged: onChange,
      style: TextStyle(color: Colors.black),
      validator: (value) {
        if (value!.isEmpty) {
          return "the value can\'t be empty";
        }
      },
      decoration: InputDecoration(
        border:OutlineInputBorder(
          borderSide: BorderSide(color:kPrimaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey)),
    );
  }
}
