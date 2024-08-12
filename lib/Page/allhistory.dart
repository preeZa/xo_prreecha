import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xo_prreecha/Page/history.dart';
import 'package:xo_prreecha/Page/home_Page.dart';

class AllHistoryPage extends StatefulWidget {
  final int number;
  const AllHistoryPage({super.key, required this.number});

  @override
  State<AllHistoryPage> createState() => _AllHistoryPageState();
}

class _AllHistoryPageState extends State<AllHistoryPage> {
  late List<Map<String, dynamic>> historyList = [];
  bool isLoad = true; // เพิ่มตัวแปร isLoad เพื่อใช้ในการควบคุมสถานะการโหลด

  @override
  void initState() {
    super.initState();
    getDataHistory();
  }

  Future<void> getDataHistory() async {
    try {
      if (widget.number == 1) {
        try {
          // ดึงข้อมูลจากคอลเล็กชัน 'historyAi'
          QuerySnapshot historyQuerySnapshot = await FirebaseFirestore.instance
              .collection('historyAi')
              .orderBy('date',
                  descending: true) // Sort by date field in descending order
              .get();

          if (historyQuerySnapshot.docs.isEmpty) {
            setState(() {
              historyList = [];
              isLoad = false;
            });
          } else {
            setState(() {
              historyList = historyQuerySnapshot.docs
                  .map((doc) {
                    final data = doc.data() as Map<String, dynamic>?;
                    if (data != null) {
                      return {
                        'id': data['id'] ?? '',
                        'win': data['win'] ?? '',
                        'oScore': data['oScore'] ?? 0,
                        'xScore': data['xScore'] ?? 0,
                        'date': data['date'] ?? '',
                        'scal': data['scal'] ?? 0,
                      };
                    } else {
                      return {};
                    }
                  })
                  .toList()
                  .cast<Map<String, dynamic>>();
              isLoad = false;
            });
          }
        } catch (error) {
          setState(() {
            isLoad = false;
          });
        }
      } else if (widget.number == 2) {
        try {
          // ดึงข้อมูลจากคอลเล็กชัน 'historyAi'

          QuerySnapshot historyQuerySnapshot = await FirebaseFirestore.instance
              .collection('history2Player')
              .orderBy('date',
                  descending: true) // Sort by date field in descending order
              .get();

          if (historyQuerySnapshot.docs.isEmpty) {
            setState(() {
              historyList = [];
              isLoad = false;
            });
          } else {
            setState(() {
              historyList = historyQuerySnapshot.docs
                  .map((doc) {
                    final data = doc.data() as Map<String, dynamic>?;
                    if (data != null) {
                      return {
                        'id': data['id'] ?? '',
                        'win': data['win'] ?? '',
                        'oScore': data['oScore'] ?? 0,
                        'xScore': data['xScore'] ?? 0,
                        'date': data['date'] ?? '',
                        'scal': data['scal'] ?? 0,
                      };
                    } else {
                      return {};
                    }
                  })
                  .toList()
                  .cast<
                      Map<String,
                          dynamic>>(); // ทำการ cast เป็น List<Map<String, dynamic>>
              isLoad = false;
            });
          }
        } catch (error) {
          // จัดการข้อผิดพลาดหากเกิดขึ้น

          setState(() {
            isLoad = false;
          });
        }
      }
    } catch (error) {
      log('Failed to get data: $error', error: error);
    } finally {
      setState(() {
        isLoad = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    'History',
                    style: TextStyle(
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
                          builder: (context) => const Homepage(),
                        ),
                        (route) =>
                            false, // This function will remove all previous routes
                      );
                    },
                  ),
                ],
              ),
            ),
            isLoad
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Expanded(
                    child: _buildHistoryList(historyList),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<Map<String, dynamic>> historyList) {
    return historyList.isEmpty
        ? const Center(
            child: Text(
              'ไม่มีประวัติ',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              return _buildCard(historyList[index]);
            },
          );
  }

  Widget _buildCard(Map<String, dynamic> historyData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryPage(
              number: widget.number,
              id: historyData['id'],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Win: ${historyData['win']}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'O Score: ${historyData['oScore']}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'X Score: ${historyData['xScore']}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Date: ${historyData['date']}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Scal: ${historyData['scal']}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 110,
                  height: 110,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10), // ปรับค่าตามต้องการ
                    child: Image.network(
                      'https://i.pinimg.com/564x/04/09/ba/0409ba4f866487c314996d96282037a1.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
