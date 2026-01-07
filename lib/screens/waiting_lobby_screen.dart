import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:doodle_it/constants/colors.dart';
import 'package:doodle_it/widgets/loader.dart';

class WaitingLobbyScreen extends StatefulWidget {
  final int occupancy;
  final int noOfPlayers;
  final String lobbyName;
  final players;
  const WaitingLobbyScreen(
      {super.key,
      required this.occupancy,
      required this.noOfPlayers,
      required this.lobbyName,
      required this.players});

  @override
  _WaitingLobbyScreenState createState() => _WaitingLobbyScreenState();
}

class _WaitingLobbyScreenState extends State<WaitingLobbyScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Text(
              'Waiting for ${widget.occupancy - widget.noOfPlayers} more players',
              style: const TextStyle(
                fontFamily: 'UK',
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            TextField(
              readOnly: true,
              onTap: () {
                // copy room code
                Clipboard.setData(ClipboardData(text: widget.lobbyName));
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Copied!')));
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: borderEnableColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: borderEnableColor,
                    width: 2.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                filled: true,
                fillColor: const Color(0xF9A679FF),
                hintText: 'Tap to copy room name!',
                hintStyle: const TextStyle(
                  fontFamily: "UK",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            const Text(
              'Players:',
              style: TextStyle(
                fontFamily: "UK",
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            Column(
              children: [
                ListView.builder(
                    // primary: true,
                    shrinkWrap: true,
                    itemCount: widget.noOfPlayers,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5).copyWith(right: 0),
                        decoration: BoxDecoration(
                            color: colorsList[index % 4],
                            borderRadius: BorderRadius.circular(20)),
                        // height: 40,
                        child: ListTile(
                          leading: Text(
                            "${index + 1}.",
                            style: const TextStyle(
                              fontFamily: "UK",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: Text(
                            widget.players[index]['nickname'],
                            style: const TextStyle(
                              fontFamily: "UK",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                const SizedBox(height: 30),
                const Loader(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
