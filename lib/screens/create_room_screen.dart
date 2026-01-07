import 'package:flutter/material.dart';
import 'package:doodle_it/constants/colors.dart';
import 'package:doodle_it/screens/paint_screen.dart';
import 'package:doodle_it/widgets/create_join_btn.dart';
import 'package:doodle_it/widgets/custom_dropdown_menu.dart';
import 'package:doodle_it/widgets/custom_text_field.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const CreateRoomScreen());

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  String _maxRoundsValue = "0";
  String _roomSizeValue = "0";
  List<String> rounds = ["2", "5", "10", "15"];
  List<String> players = ["2", "3", "4", "5", "6", "7", "8", "9", "10"];
  Color createColor = colorsList[0];

  set stringRounds(String value) => setState(() => _maxRoundsValue = value);
  set stringPlayers(String value) => setState(() => _roomSizeValue = value);

  void createRoom() {
    if (nameController.text.isNotEmpty &&
        roomController.text.isNotEmpty &&
        _maxRoundsValue != null &&
        _roomSizeValue != null) {
      Map<String, String> data = {
        "nickname": nameController.text,
        "name": roomController.text,
        "maxRounds": _maxRoundsValue!,
        "occupancy": _roomSizeValue!,
      };
      Navigator.push(context, PaintScreen.route(data, 'createRoom'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                const SizedBox(),
                const Text(
                  "Create Room",
                  style: TextStyle(
                    fontFamily: 'UK',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(),
                Column(
                  children: [
                    CustomTextField(
                      controller: nameController,
                      hintText: "Enter Your Name",
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: roomController,
                      hintText: "Enter Room Name",
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomDropdownMenu(
                          cnt: _maxRoundsValue,
                          list: rounds,
                          word: "Rounds",
                          changeValue: (value) {
                            _maxRoundsValue = value!;
                            setState(() {});
                          },
                        ),
                        CustomDropdownMenu(
                          cnt: _roomSizeValue,
                          list: players,
                          word: "Players",
                          changeValue: (value) {
                            _roomSizeValue = value!;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(),
                const SizedBox(),
                CustomBtn(
                  fn: createRoom,
                  btnText: "Create",
                  btnColor: createColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

typedef void StringCallback(String val);
