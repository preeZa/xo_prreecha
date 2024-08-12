import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:xo_prreecha/Page/allhistory.dart';


class XogamePage extends StatefulWidget {
  final int number;
  const XogamePage({super.key, required this.number});

  @override
  State<XogamePage> createState() => _XogamePageState();
}

class _XogamePageState extends State<XogamePage> {
  bool oturn = true;
  late int scal; // จำนวนคอลัมน์ในกริด
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  late int doubleScal;
  late List<String> displayXO;
  static const maxSeconds = 30;
  int seconds = maxSeconds;
  Timer? timer;
  List<int> winPositions = [];
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  void resetTimer() {
    seconds = maxSeconds;
  }

  @override
  void initState() {
    super.initState();
    scal = widget.number;
    doubleScal = scal * scal; // จำนวนช่องทั้งหมดในกริด
    displayXO = List.generate(doubleScal, (index) => '');
  }

  @override
  Widget build(BuildContext context) {
    double fontSize;
    if (scal < 5) {
      fontSize = 40;
    } else if (scal < 8) {
      fontSize = 20;
    } else if (scal <= 12) {
      fontSize = 10;
    } else if (scal <= 16) {
      fontSize = 7;
    } else {
      fontSize = 4;
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 60, left: 10, right: 10),
              padding: const EdgeInsets.all(10),
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                  bottom: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    'XO 2 Player',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.history, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllHistoryPage(number: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Player O',
                        style: GoogleFonts.coiny(
                            textStyle: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 3,
                          fontSize: 28,
                        )),
                      ),
                      Text(
                        oScore.toString(),
                        style: GoogleFonts.coiny(
                            textStyle: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 3,
                          fontSize: 28,
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Player X',
                        style: GoogleFonts.coiny(
                            textStyle: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 3,
                          fontSize: 28,
                        )),
                      ),
                      Text(
                        xScore.toString(),
                        style: GoogleFonts.coiny(
                            textStyle: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 3,
                          fontSize: 28,
                        )),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              flex: 3,
              child: GridView.builder(
                itemCount: doubleScal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: scal, // จำนวนคอลัมน์ในกริด
                  mainAxisSpacing: 8.0, // ระยะห่างระหว่างแถว
                  crossAxisSpacing: 8.0, // ระยะห่างระหว่างคอลัมน์
                ),
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      _tapped(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: winPositions.contains(index)
                            ? const Color.fromARGB(255, 139, 40, 156)
                            : Colors.white, // สีพื้นหลังของกริด
                        borderRadius:
                            BorderRadius.circular(15), // มุมโค้งของกรอบ
                        border: Border.all(
                          color: Colors.black, // สีของกรอบ
                          width: 2, // ความกว้างของกรอบ
                        ),
                      ),
                      child: Center(
                        child: Text(
                          displayXO[index],
                          style: GoogleFonts.coiny(
                            textStyle: TextStyle(
                              fontSize: fontSize, // ใช้ fontSize ที่คำนวณไว้
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTime(),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTime() {
    final isRunning = timer != null && timer!.isActive;
    double progressValue = 1 - (seconds / maxSeconds);

    return SizedBox(
      width: 80,
      height: 80,
      child: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: isRunning ? progressValue : 30,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              strokeWidth: 8,
              backgroundColor: const Color.fromARGB(255, 195, 174, 235),
            ),
            Center(
              child: Text(
                '$seconds',
                style: GoogleFonts.coiny(
                  textStyle: const TextStyle(
                    fontSize: 24, // ใช้ fontSize ที่คำนวณไว้
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _tapped(int index) {
    stopTimer();
    resetTimer();
    startTimer();
    setState(() {
      if (displayXO[index] == '') {
        if (oturn) {
          displayXO[index] = 'O';
        } else {
          displayXO[index] = 'X';
        }
        filledBoxes++;
        oturn = !oturn;
        _checkWinner();
      }
    });
  }

  void _checkWinner() {
    winPositions = []; 
    String winner = _checkRowsAndColumns();
    if (winner.isNotEmpty) {
      _showWinner(winner);
      return;
    }

    winner = _checkDiagonals();
    if (winner.isNotEmpty) {
      _showWinner(winner);
      return;
    }

    if (filledBoxes == doubleScal) {
      _showWinner('');
    }
  }

  String _checkRowsAndColumns() {
    for (int i = 0; i < scal; i++) {
      // แถว
      List<int> rowPositions = List.generate(scal, (index) => i * scal + index);
      String rowWinner =
          _checkLine(displayXO.sublist(i * scal, (i + 1) * scal), rowPositions);
      if (rowWinner.isNotEmpty) {
        return rowWinner;
      }

      // คอลัมน์
      List<int> colPositions = List.generate(scal, (index) => index * scal + i);
      String colWinner = _checkLine(
          List.generate(scal, (index) => displayXO[index * scal + i]),
          colPositions);
      if (colWinner.isNotEmpty) {
        return colWinner;
      }
    }
    return '';
  }

  String _checkDiagonals() {
    // ทแยงมุมซ้ายบนไปขวาล่าง
    List<int> diag1Positions =
        List.generate(scal, (index) => index * scal + index);
    String diag1Winner = _checkLine(
        List.generate(scal, (index) => displayXO[index * scal + index]),
        diag1Positions);
    if (diag1Winner.isNotEmpty) {
      return diag1Winner;
    }

    // ทแยงมุมขวาบนไปซ้ายล่าง
    List<int> diag2Positions =
        List.generate(scal, (index) => index * scal + (scal - 1 - index));
    String diag2Winner = _checkLine(
        List.generate(
            scal, (index) => displayXO[index * scal + (scal - 1 - index)]),
        diag2Positions);
    if (diag2Winner.isNotEmpty) {
      return diag2Winner;
    }

    return '';
  }

  String _checkLine(List<String> line, List<int> positions) {
    String firstCell = line[0];
    if (firstCell.isEmpty) return '';
    if (line.every((cell) => cell == firstCell)) {
      winPositions = positions; 
      return firstCell;
    }
    return '';
  }

  void _showWinner(String winner) {
    stopTimer();
    print(winPositions);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
                  winner.isEmpty ? 'Game Draw!' : 'Player $winner Winner')),
          actions: [
            TextButton(
              onPressed: () {
                if (winner == 'O') {
                  setState(() {
                    oScore++;
                    addHistory(
                      'Player O',
                    );
                  });
                } else if (winner == 'X') {
                  setState(() {
                    xScore++;
                    addHistory('Player X');
                  });
                } else {
                  addHistory('Draw');
                }
                Navigator.of(context).pop(); // ปิด Dialog ก่อน
                setState(() {
                  winPositions = [];
                  displayXO = List.generate(doubleScal, (index) => '');
                  filledBoxes = 0; // รีเซ็ตจำนวนช่องที่ถูกเติม
                });
              },
              child: const Center(child: Text('OK')),
            ),
          ],
        );
      },
    );
  }

  void addHistory(String name) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final String formatted =
        formatter.format(now.toUtc().add(const Duration(hours: 7)));
    CollectionReference collHistory2Player =
        FirebaseFirestore.instance.collection('history2Player');
    try {
      DocumentReference newHisRef = await collHistory2Player.add({
        'win': name,
        'oScore': oScore,
        'xScore': xScore,
        'broad': displayXO,
        'date': formatted,
        'winPosition': winPositions,
        'scal': scal
      });
      String docId = newHisRef.id;
      await newHisRef.update({'id': docId});
    } catch (error) {
      (error.toString());
    }
  }
}
