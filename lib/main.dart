import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boarding Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BoardingScreen(),
    );
  }
}

class BoardingScreen extends StatefulWidget {
  @override
  _BoardingScreenState createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  int _timeLeft = 120;
  Timer? _timer;
  bool _isRunning = false;

  List<List<int>> stressLevels = List.generate(4, (_) => List.filled(6, 0));
  List<bool> delayed = List.filled(4, false);
  List<int> leftBehind = List.filled(4, 0);

  void _startTimer() {
    if (_timer != null && _timer!.isActive) return;
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _showPopup();
          _timer?.cancel();
          _isRunning = false;
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _timeLeft = 120;
      _isRunning = false;
    });
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Time Up!'),
        content: Text('Next Step'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  int calculateScore() {
    int stressScore =
        stressLevels.expand((row) => row).fold(0, (sum, num) => sum + num);
    int delayScore = delayed.where((d) => d).length * 10;
    int leftBehindScore = leftBehind.fold(0, (sum, num) => sum + num * 20);
    return stressScore + delayScore + leftBehindScore;
  }

  String getScoreEmoji(int score) {
    if (score < 20) return '😃';
    if (score < 40) return '🙂';
    if (score < 60) return '😐';
    if (score < 80) return '😟';
    if (score < 100) return '😣';
    if (score < 120) return '😫';
    if (score < 140) return '😨';
    if (score < 160) return '😰';
    if (score < 180) return '🥵';
    if (score < 200) return '😱';
    return '🔥';
  }

  @override
  Widget build(BuildContext context) {
    int score = calculateScore();
    return Scaffold(
        appBar: AppBar(title: Text('Boarding Manager')),
        body: SingleChildScrollView(
            child: SizedBox(
          height: 720,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Time left: $_timeLeft s",
                      style: TextStyle(fontSize: 24)),
                  IconButton(
                      icon: Icon(Icons.play_arrow), onPressed: _startTimer),
                  IconButton(icon: Icon(Icons.pause), onPressed: _pauseTimer),
                  IconButton(icon: Icon(Icons.refresh), onPressed: _resetTimer),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    _buildBoardingArea(),
                    _buildDelayArea(),
                    _buildMissingPassengersArea(),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(getScoreEmoji(score),
                              style: TextStyle(fontSize: 40)),
                          Text("Passengers Agony: $score",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }

  Widget _buildBoardingArea() {
    List<String> colors = ['Red', 'Blue', 'Yellow', 'Green'];
    List<Color> bgColors = [
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.green
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (colIndex) {
        return Column(
          children: [
            Text(colors[colIndex],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(6, (rowIndex) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (stressLevels[colIndex][rowIndex] < 6) {
                      stressLevels[colIndex][rowIndex]++;
                    } else {
                      stressLevels[colIndex][rowIndex] = 0;
                    }
                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: bgColors[colIndex],
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                      stressLevels[colIndex][rowIndex] == 0
                          ? ''
                          : stressLevels[colIndex][rowIndex].toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              );
            })
          ],
        );
      }),
    );
  }

  Widget _buildDelayArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Column(
          children: [
            Text("Delayed"),
            Switch(
              value: delayed[index],
              onChanged: (value) {
                setState(() {
                  delayed[index] = value;
                });
              },
            )
          ],
        );
      }),
    );
  }

  Widget _buildMissingPassengersArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Column(
          children: [
            Text("Missed"),
            GestureDetector(
              onTap: () {
                setState(() {
                  leftBehind[index] = (leftBehind[index] + 1) % 7;
                });
              },
              child: Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.all(4),
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Text(leftBehind[index].toString(),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        );
      }),
    );
  }
}
