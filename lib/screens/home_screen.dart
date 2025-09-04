import 'package:flutter/material.dart';
import 'package:skribble_io/screens/create_room_screen.dart';
import 'package:skribble_io/screens/join_room_screen.dart';
import 'package:skribble_io/widgets/create_join_btn.dart';

import '../constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  static route() => MaterialPageRoute(builder: (context) => const HomeScreen());
}

class _HomeScreenState extends State<HomeScreen> {
  Color createColor = colorsList[0];
  Color joinColor = colorsList[1];
  void toCreateScreen() {
    Navigator.push(context, CreateRoomScreen.route());
  }

  void toJoinScreen() {
    Navigator.push(context, JoinRoomScreen.route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                const Text(
                  "Create or Join a room",
                  style: TextStyle(
                    fontFamily: 'UK',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomBtn(
                      fn: toCreateScreen,
                      btnText: "Create",
                      btnColor: createColor,
                    ),
                    CustomBtn(
                      fn: toJoinScreen,
                      btnText: "Join",
                      btnColor: joinColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
