import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xo_prreecha/Page/home_Page.dart';

class HistoryPage extends StatefulWidget {
  final int number;
  final String id;
  const HistoryPage({super.key, required this.number, required this.id});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int scal = 0; // Number of columns in grid
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  int doubleScal = 9;
  late List<String> displayXO;
  List<int> winPositions = [];
  String win = '';
  late Map<String, dynamic> data = {};
  bool isLoad = false;
  String title = '';

  @override
  void initState() {
    super.initState();
    getDataHistory();
  }

  Future<void> getDataHistory() async {
    try {
      if (widget.number == 1) {
        DocumentSnapshot historyQuerySnapshot = await FirebaseFirestore.instance
            .collection('historyAi')
            .doc(widget.id)
            .get();

        if (historyQuerySnapshot.exists) {
          // Check if document exists
          setState(() {
            data = historyQuerySnapshot.data() as Map<String, dynamic>? ?? {};
            scal = data['scal'] ?? 3; // Use default if Firestore value is null
            oScore = data['oScore'] ?? 0;
            xScore = data['xScore'] ?? 0;
            winPositions = List<int>.from(data['winPosition'] ?? []);
            displayXO = List<String>.from(
                data['broad'] ?? List.generate(doubleScal, (index) => ''));
            win = data['win'] ?? '';
            doubleScal = scal * scal;
            title = 'Ai';
            isLoad = true;
          });
        }
      } else if (widget.number == 2) {
        DocumentSnapshot historyQuerySnapshot = await FirebaseFirestore.instance
            .collection('history2Player')
            .doc(widget.id)
            .get();

        if (historyQuerySnapshot.exists) {
          // Check if document exists
          setState(() {
            data = historyQuerySnapshot.data() as Map<String, dynamic>? ?? {};
            scal = data['scal'] ?? 3; // Use default if Firestore value is null
            oScore = data['oScore'] ?? 0;
            xScore = data['xScore'] ?? 0;
            winPositions = List<int>.from(data['winPosition'] ?? []);
            displayXO = List<String>.from(
                data['broad'] ?? List.generate(doubleScal, (index) => ''));
            win = data['win'] ?? '';
            doubleScal = scal * scal;
            title = '2 Player';
            isLoad = true;
          });
        }
      }
    } catch (error) {
      log('Failed to get data: $error', error: error);
    }
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
    return isLoad
        ? Scaffold(
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
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'History $title',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.home, color: Colors.black),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>const Homepage(),
                              ),
                              (route) =>
                                  false, // This function will remove all previous routes
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
                          onTap: () {},
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
                                    fontSize:
                                        fontSize, // ใช้ fontSize ที่คำนวณไว้
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
                        Text(
                          '$win Win',
                          style: GoogleFonts.coiny(
                            textStyle: TextStyle(
                              fontSize: fontSize, // ใช้ fontSize ที่คำนวณไว้
                              color: const Color.fromARGB(255, 252, 252, 252),
                            ),
                          ),
                        )
                      ],
                    )),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
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
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.black),
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
                            // Action when "history" icon is pressed
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
