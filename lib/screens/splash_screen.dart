import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:doodle_it/constants/colors.dart';
import 'package:doodle_it/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 2),
      () {
        Navigator.pushReplacementNamed(context, HomeScreen.route());
      },
    );
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        // height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/paintScreenBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  "SKRIBBLE",
                  style: TextStyle(
                    fontFamily: 'USA',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                  ),
                )
                    .animate()
                    .slideX(
                      begin: 1,
                      end: 0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeIn,
                    )
                    .fade(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(milliseconds: 700),
                    ),
                const Text(
                  ".",
                  style: TextStyle(
                    fontFamily: 'USA',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                  ),
                ).animate().fadeIn(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(seconds: 1),
                    ),
                const Text(
                  "i",
                  style: TextStyle(
                    fontFamily: 'USA',
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                    color: Colors.red,
                  ),
                )
                    .animate()
                    .slideX(
                      begin: -3,
                      end: 0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeIn,
                    )
                    .fadeIn(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(milliseconds: 700),
                    ),
                const Text(
                  "o",
                  style: TextStyle(
                    fontFamily: 'USA',
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                    color: Colors.blue,
                  ),
                )
                    .animate()
                    .slideX(
                      begin: -3,
                      end: 0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeIn,
                    )
                    .fadeIn(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(milliseconds: 700),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
