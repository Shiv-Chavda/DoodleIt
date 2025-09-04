import 'package:flutter/material.dart';
import 'package:skribble_io/constants/colors.dart';
import 'package:skribble_io/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skribble.io',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: backgroundColor,
        shadowColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}
