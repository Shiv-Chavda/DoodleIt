import 'package:flutter/material.dart';
import 'package:doodle_it/constants/colors.dart';
import 'package:doodle_it/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoodleIt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: backgroundColor,
        shadowColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}
