// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:doodle_it/constants/colors.dart';
import 'package:doodle_it/constants/server_config.dart';
import 'package:doodle_it/screens/final_leaderboard.dart';
import 'package:doodle_it/screens/home_screen.dart';
import 'package:doodle_it/screens/waiting_lobby_screen.dart';
import 'package:doodle_it/sidebar/player_scoreboard_drawer.dart';
import 'package:doodle_it/widgets/loader.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/my_custom_painter.dart';
import '../models/touch_points.dart';

class PaintScreen extends StatefulWidget {
  const PaintScreen({super.key, required this.data, required this.screenFrom});

  final Map<String, String> data;
  final String screenFrom;

  static route(Map<String, String> data, String screenFrom) =>
      MaterialPageRoute(
          builder: (context) => PaintScreen(
                data: data,
                screenFrom: screenFrom,
              ));

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  late IO.Socket _socket;
  Map<String, dynamic>? dataOfRoom;
  List<TouchPoints?> points = [];
  StrokeCap strokeType = StrokeCap.round;
  Color selectedColor = Colors.black;
  double opacity = 1;
  double strokeWidth = 2;
  List<Widget> textBlankWidget = [];
  ScrollController _scrollController = ScrollController();
  List<Map> messages = [];
  TextEditingController _msgController = TextEditingController();
  int guessedUserCtr = 0;
  int start = 60;
  late Timer _timer;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map> scoreBoard = [];
  bool isTextInputReadOnly = false;
  int maxPoints = 0;
  String winner = "";
  bool isShowFinalLeaderBoard = false;

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _socket.dispose();
  }

  void renderText(String text) {
    textBlankWidget.clear();
    for (int i = 0; i < text.length; i++) {
      textBlankWidget.add(const Text(
        '_',
        style: TextStyle(fontSize: 30),
      ));
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer time) {
      if (start == 0) {
        _socket.emit('change-turn', dataOfRoom?['name']);
        setState(() {
          _timer.cancel();
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  void connect() async {
    print("Connecting to server...");
    try {
      _socket = IO.io(ServerConfig.serverUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      _socket.connect();

      //on establishing connection with socket
      _socket.onConnect((data) {
        print("connected successfully to socket");

        // emit create/join now that socket is connected
        if (widget.screenFrom == 'createRoom') {
          _socket.emit('create-game', widget.data);
        } else {
          _socket.emit('join-game', widget.data);
        }

        //not correct game
        _socket.on(
            'notCorrectGame',
            (data) => Navigator.of(context).pushAndRemoveUntil(
                  HomeScreen.route(),
                  (route) => false,
                ));

        //on changes in the room
        _socket.on('updateRoom', (roomData) {
          print("update room");
          setState(() {
            renderText(roomData['word']);
            dataOfRoom = roomData;
          });
          if (roomData['isJoin'] != true) {
            startTimer();
          }
          scoreBoard.clear();
          if (dataOfRoom?['players'] is List) {
            for (int i = 0; i < dataOfRoom!['players'].length; i++) {
              setState(() {
                scoreBoard.add({
                  'username': dataOfRoom!['players'][i]['nickname'],
                  'points': dataOfRoom!['players'][i]['points'].toString(),
                });
              });
            }
          }
        });

        //on painting the screen
        _socket.on('points', (point) {
          if (point['details'] != null) {
            setState(() {
              points.add(
                TouchPoints(
                  points: Offset(
                    (point['details']['dx']).toDouble(),
                    (point['details']['dy']).toDouble(),
                  ),
                  paint: Paint()
                    ..strokeCap = strokeType
                    ..isAntiAlias = true
                    ..strokeWidth = strokeWidth
                    ..color = selectedColor.withOpacity(opacity),
                ),
              );
            });
          } else {
            setState(() {
              points.add(null);
            });
          }
        });
      });

      //on changing the color
      _socket.on('color-change', (colorString) {
        int value = int.parse(colorString, radix: 16);
        Color otherColor = Color(value);
        setState(() {
          selectedColor = otherColor;
        });
      });

      //on changing the stroke width
      _socket.on('stroke-width', (value) {
        setState(() {
          strokeWidth = value;
        });
      });

      //on clear screen
      _socket.on('clear-screen', (data) {
        setState(() {
          points.clear();
        });
      });

      //on msg
      _socket.on('msg', (data) {
        setState(() {
          messages.add(data);
          guessedUserCtr = data['guessedUserCtr'];
        });
        //on guessed by all the users
        if (dataOfRoom?['players'] is List &&
            guessedUserCtr == dataOfRoom!['players'].length - 1) {
          _socket.emit('change-turn', dataOfRoom?['name']);
        }
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 40,
          duration: const Duration(milliseconds: 20),
          curve: Curves.easeInOut,
        );
      });

      //on changing the turn of user
      _socket.on('change-turn', (room) {
  String oldWord = dataOfRoom?['word'] ?? '';

        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 3), () {
                setState(() {
                  dataOfRoom = room;
                  renderText(room['word']);
                  isTextInputReadOnly = false;
                  start = 60;
                  guessedUserCtr = 0;
                  points.clear();
                });
                Navigator.of(context).pop();
                _timer.cancel();
                startTimer();
              });
              return AlertDialog(
                title: Center(
                  child: Text("the word was $oldWord"),
                ),
              );
            });
      });

      _socket.on('close-input', (_) {
        _socket.emit('update-score', widget.data['name']);
        setState(() {
          isTextInputReadOnly = true;
        });
      });

      //updating the scoreboard
      _socket.on('update-score', (roomData) {
        scoreBoard.clear();
        if (dataOfRoom?['players'] is List) {
          for (int i = 0; i < dataOfRoom!['players'].length; i++) {
            setState(() {
              scoreBoard.add({
                'username': dataOfRoom!['players'][i]['nickname'],
                'points': dataOfRoom!['players'][i]['points'].toString(),
              });
            });
          }
        }
      });

      //leaderboard
      _socket.on('show-leaderboard', (roomPlayer) {
        scoreBoard.clear();
        if (roomPlayer is List) {
          for (int i = 0; i < roomPlayer.length; i++) {
            setState(() {
              scoreBoard.add({
                'username': roomPlayer[i]['nickname'],
                'points': roomPlayer[i]['points'].toString(),
              });
              if (maxPoints < int.parse(scoreBoard[i]['points'])) {
                winner = scoreBoard[i]['username'];
                maxPoints = int.parse(scoreBoard[i]['points']);
              }
            });
            setState(() {
              _timer.cancel();
              isShowFinalLeaderBoard = true;
            });
          }
        }
      });

      _socket.onConnectError((data) {
        print("Connection failed (Dart): $data");
      });

      //on user disconnected
      _socket.on('user-disconnected', (data) {
        scoreBoard.clear();
        for (int i = 0; i < data['players'].length; i++) {
          setState(() {
            scoreBoard.add({
              'username': data['players'][i]['nickname'],
              'points': data['players'][i]['points'].toString()
            });
          });
        }
      });

      print("Connected!");
    } catch (error) {
      print("Error connecting: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    void selectColor() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Choose Color'),
                content: SingleChildScrollView(
                  child: BlockPicker(
                      pickerColor: selectedColor,
                      onColorChanged: (color) {
                        String colorString = color.toString();
                        String valueString =
                            colorString.split('(0x')[1].split(')')[0];
                        print(colorString);
                        print(valueString);
                        Map map = {
                          'color': valueString,
                          'roomName': dataOfRoom?['name']
                        };
                        _socket.emit('color-change', map);
                      }),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'))
                ],
              ));
    }

    // If room data hasn't arrived yet, show loader early to avoid nullable problems
    if (dataOfRoom == null) {
      return Scaffold(
        key: scaffoldKey,
        drawer: PlayerScore(userData: scoreBoard,),
        backgroundColor: Colors.white,
        body: const Center(child: Loader()),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: FloatingActionButton(
            elevation: 10,
            onPressed: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: backgroundColor,
            child: !isShowFinalLeaderBoard
                ? Text(
                    '$start',
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: 'UK',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                    ),
                  ),
          ),
        ),
      );
    }

  return Scaffold(
      key: scaffoldKey,
      drawer: PlayerScore(
        userData: scoreBoard,
      ),
      backgroundColor: Colors.white,
  body: (dataOfRoom?['isJoin'] ?? false) != true
        ? !isShowFinalLeaderBoard
          ? Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: width,
                              height: height * .55,
                              child: GestureDetector(
                                onPanStart: (details) {
                                  _socket.emit('paint', {
                                    'details': {
                                      'dx': details.localPosition.dx,
                                      'dy': details.localPosition.dy,
                                    },
                                    'roomName': widget.data['name'],
                                  });
                                },
                                onPanUpdate: (details) {
                                  _socket.emit('paint', {
                                    'details': {
                                      'dx': details.localPosition.dx,
                                      'dy': details.localPosition.dy,
                                    },
                                    'roomName': widget.data['name'],
                                  });
                                },
                                onPanEnd: (details) {
                                  _socket.emit('paint', {
                                    'details': null,
                                    'roomName': widget.data['name'],
                                  });
                                },
                                child: SizedBox.expand(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    child: CustomPaint(
                                      size: Size.infinite,
                                      painter:
                                          MyCustomPainter(pointsList: points),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: backgroundColor,
                              margin: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: selectColor,
                                    icon: Icon(
                                      Icons.color_lens,
                                      color: selectedColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: Slider(
                                      min: 1,
                                      max: 10,
                                      label: 'StrokeWidth $strokeWidth',
                                      value: strokeWidth,
                                      onChanged: (double value) {
                                        Map map = {
                                          'value': value,
                                          'roomName': dataOfRoom?['name'],
                                        };
                                        _socket.emit('stroke-width', map);
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                    _socket.emit(
                      'clear-screen', dataOfRoom?['name']);
                                    },
                                    icon: Icon(
                                      Icons.layers_clear,
                                      color: selectedColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
          dataOfRoom?['turn']?['nickname'] !=
            (widget.data['nickname'] ?? 'Guest')
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: textBlankWidget,
                                  )
                                : Center(
                                    child: Text(dataOfRoom?['word'] ?? ''),
                                  ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: ListView.builder(
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    var msg = messages[index].values;
                                    print(msg);
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      color: msg.elementAt(1) == 'Guessed it!'
                                          ? Colors.greenAccent
                                          : index % 2 == 0
                                              ? Colors.white
                                              : Colors.grey,
                                      child: ListTile(
                                        leading: Text(
                                          msg.elementAt(0),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontFamily: "USA",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        title: Text(
                                          msg.elementAt(1),
                                          style: const TextStyle(
                                            fontFamily: "USA",
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
      dataOfRoom?['turn']?['nickname'] !=
        (widget.data['nickname'] ?? 'Guest')
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: TextField(
                                  readOnly: isTextInputReadOnly,
                                  controller: _msgController,
                                  onSubmitted: (value) {
                                    if (value.trim().isNotEmpty) {
                                      print("data of dataOfRoom $dataOfRoom");
                                      Map map = {
                                        'username': widget.data['nickname'] ?? 'Guest',
                                        'msg': value.trim(),
                                        'word': dataOfRoom?['word'] ?? '',
                                        'roomName': widget.data['name'],
                                        'guessedUserCtr': guessedUserCtr,
                                        'totalTime': 60,
                                        'timeTaken': 60 - start,
                                      };
                                      print("sending data on msg $map");
                                      _socket.emit('msg', map);
                                      _msgController.clear();
                                    }
                                  },
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                    hintText: "Guess word",
                                    hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 18),
                                    filled: true,
                                    fillColor: const Color(0xffF5F5FA),
                                  ),
                                  textInputAction: TextInputAction.done,
                                ),
                              )
                            : Container(),
                        SafeArea(
                          child: IconButton(
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.black,
                            ),
                            onPressed: () =>
                                scaffoldKey.currentState!.openDrawer(),
                          ),
                        ),
                      ],
                    )
                  : FianlLeaderBoard(scoreboard: scoreBoard)
              : WaitingLobbyScreen(
            lobbyName: dataOfRoom?['name'] ?? '',
              noOfPlayers: (dataOfRoom?['players'] is List)
                ? dataOfRoom!['players'].length
                : 0,
              occupancy: dataOfRoom?['occupancy'] ?? 0,
              players: dataOfRoom?['players'] ?? [],
                ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton(
          elevation: 10,
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: backgroundColor,
          child: !isShowFinalLeaderBoard
              ? Text(
                  '$start',
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'UK',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                  ),
                ),
        ),
      ),
    );
  }
}
