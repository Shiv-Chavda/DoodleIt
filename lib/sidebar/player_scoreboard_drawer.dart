import 'package:flutter/material.dart';

class PlayerScore extends StatelessWidget {
  const PlayerScore({super.key, required this.userData});
  final List<Map> userData;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: Container(
          height: double.maxFinite,
          child: ListView.builder(
              itemCount: userData.length,
              itemBuilder: (context, index) {
                var data = userData[index].values;
                return ListTile(
                  title: Text(
                    data.elementAt(0),
                    style: const TextStyle(color: Colors.black, fontSize: 23),
                  ),
                  trailing: Text(
                    data.elementAt(1),
                    style: const TextStyle(color: Colors.black, fontSize: 23),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
