import 'package:flutter/material.dart';
import 'package:skribble_io/constants/colors.dart';

class CustomDropdownMenu extends StatefulWidget {
  CustomDropdownMenu({
    super.key,
    required this.cnt,
    required this.list,
    required this.word,
    required this.changeValue,
  });
  String? cnt;
  final String word;
  final List<String> list;
  Function(String? value) changeValue;
  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      borderRadius: BorderRadius.circular(15),
      dropdownColor: backgroundColor,
      underline: const SizedBox(),
      items: widget.list
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  fontFamily: "USA",
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
      hint: widget.cnt == "0"
          ? Text(
              "Max ${widget.word}",
              style: const TextStyle(
                fontFamily: 'USA',
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            )
          : Text(
              "${widget.word}: ${widget.cnt}",
              style: const TextStyle(
                fontFamily: 'USA',
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
      onChanged: (String? value) {
        setState(() {
          widget.cnt = value;
          print("value changed: $widget.cnt");
          widget.changeValue(value);
        });
      },
    );
  }
}
