import 'package:flutter/material.dart';

import '../constants/colors.dart';

class FianlLeaderBoard extends StatelessWidget {
  final scoreboard;
  const FianlLeaderBoard({super.key, this.scoreboard});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        height: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/paintScreenBackground.jpg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                "SCOREBOARD",
                style: TextStyle(
                  fontFamily: "UK",
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ListView.builder(
                primary: true,
                shrinkWrap: true,
                itemCount: scoreboard.length,
                itemBuilder: (context, index) {
                  var data = scoreboard[index].values;
                  return Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5).copyWith(right: 0),
                    decoration: BoxDecoration(
                      color: colorsList[index % 4],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: Text(
                        data.elementAt(0),
                        style: const TextStyle(
                          fontFamily: "UK",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Text(
                        data.elementAt(1),
                        style: const TextStyle(
                          fontFamily: "UK",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
