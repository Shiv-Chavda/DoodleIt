import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key, required this.controller, required this.hintText});
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontFamily: "UK",
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(15),
        //   borderSide: const BorderSide(color: Color(0xffcc9eca), width: 2.5),
        // ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderEnableColor, width: 2.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderEnableColor, width: 2.5),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: "USA",
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        filled: true,
        fillColor: backgroundColor,
      ),
    );
  }
}
