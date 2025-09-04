import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  CustomBtn({
    super.key,
    required this.fn,
    required this.btnText,
    required this.btnColor,
  });
  Function fn;
  final String btnText;
  final Color btnColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        fn();
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            btnText,
            style: TextStyle(
              fontFamily: 'UK',
              fontSize: 20,
              color: btnColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
