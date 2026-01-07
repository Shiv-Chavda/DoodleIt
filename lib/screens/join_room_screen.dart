import 'package:flutter/material.dart';
import 'package:doodle_it/screens/paint_screen.dart';
import 'package:doodle_it/widgets/create_join_btn.dart';

import '../constants/colors.dart';
import '../widgets/custom_text_field.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
  static route() =>
      MaterialPageRoute(builder: (context) => const JoinRoomScreen());
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  Color joinColor = colorsList[1];

  void joinRoom() {
    if (nameController.text.isNotEmpty && roomController.text.isNotEmpty) {
      Map<String, String> data = {
        "nickname": nameController.text,
        "name": roomController.text,
      };
      Navigator.push(context, PaintScreen.route(data, 'joinRoom'));
    }
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
                  "Join Room",
                  style: TextStyle(
                    fontFamily: 'UK',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Column(
                  children: [
                    CustomTextField(
                      controller: nameController,
                      hintText: "enter your name",
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: roomController,
                      hintText: "enter room name",
                    ),
                  ],
                ),
                const SizedBox(),
                CustomBtn(
                  fn: joinRoom,
                  btnText: "Join",
                  btnColor: joinColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
