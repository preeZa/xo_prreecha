import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:xo_prreecha/Page/allhistory.dart';

class XoAiPage extends StatefulWidget {
  final int number;
  const XoAiPage({super.key, required this.number});

  @override
  State<XoAiPage> createState() => _XoAiPageState();
}

class _XoAiPageState extends State<XoAiPage> {
  bool oturn = true;
  late int scal; // จำนวนคอลัมน์ในกริด
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  late int doubleScal;
  late List<List<String>> displayXO; // เปลี่ยนเป็น 2D List
  static const maxSeconds = 30;
  int seconds = maxSeconds;
  Timer? timer;
  List<List<int>> winPositions = [];
  bool gameOver = false;
  List<String> displayXO_1Array = [];
  List<int> winPositions_1Array = [];

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
    displayXO = List.generate(
        scal,
        (i) => List.generate(
            scal, (j) => '')); // กำหนดค่าเริ่มต้นเป็นกริดที่ว่างเปล่า
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
                    'XO AI',
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
                          builder: (context) => const AllHistoryPage(number: 1),
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
                    width: 60,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'AI X',
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
                  crossAxisCount: scal,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (BuildContext context, int index) {
                  int row = index ~/ scal;
                  int col = index % scal;
                  bool isWinningPosition = winPositions.any(
                    (position) => position[0] == row && position[1] == col,
                  );
                  return GestureDetector(
                    onTap: () {
                      if (oturn && displayXO[row][col] == '' && !gameOver) {
                        _tapped(row, col);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isWinningPosition
                            ? const Color.fromARGB(255, 139, 40, 156)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          displayXO[row][col],
                          style: GoogleFonts.coiny(
                            textStyle: TextStyle(
                              fontSize: fontSize,
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
                    fontSize: 24,
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

  void _tapped(int row, int col) {
    stopTimer();
    resetTimer();
    startTimer();
    if (displayXO[row][col] == '' && !gameOver) {
      setState(() {
        displayXO[row][col] = oturn ? 'O' : 'X';
        filledBoxes++;
        oturn = !oturn;
      });
      _checkWinner();
      if (!gameOver && !oturn && scal == 3) {
        _aiMoveHard();
      } else if (!gameOver && !oturn) {
        // เรียก AI เพื่อให้ทำการเคลื่อนไหวถัดไป
        Future.delayed(const Duration(milliseconds: 5), _aiMove);
      }
    }
  }

  void _aiMoveHard() {
    displayXO_1Array = [];
    for (var i = 0; i < scal; i++) {
      for (var j = 0; j < scal; j++) {
        if ( displayXO[i][j] == '') {
          displayXO_1Array.add('');
        }else{
          displayXO_1Array.add(displayXO[i][j]);
        }
         // ใช้ null-aware operator
      }
    }

    int bestMove = _findBestMoveScal3();
    // ทำการเคลื่อนไหวที่ดีที่สุด
    _makeMoveScal3(bestMove, 'X'); // เปลี่ยนเป็น 'O' แทน 'X'
  }

  void _makeMoveScal3(int index, String player) {
    if (index < 0 || index >= displayXO_1Array.length) {
      // ตรวจสอบว่าตำแหน่งที่กำหนดถูกต้อง
      return;
    }

    if (displayXO_1Array[index] == '') {
      int row = index ~/ 3; // ใช้การหารเฉลี่ยเพื่อหาตำแหน่งแถว
      int col = index % 3; // ใช้การหารเพื่อหาตำแหน่งคอลัมน์

      setState(() {
        displayXO[row][col] = player; // ทำการเคลื่อนไหว
        filledBoxes++;
        _checkWinner();
        oturn = !oturn;
      });
    }
  }

  int _findBestMoveScal3() {
    int bestMove = -1;
    int bestValue = -1000;
    int depth = 3; // ตั้งค่าความลึกที่ต้องการ

    for (int i = 0; i < 9; i++) {
      if (displayXO_1Array[i] == '') {
        displayXO_1Array[i] = 'O'; // ทดสอบการเคลื่อนไหว

        // ตรวจสอบการชนะทันที
        if (_checkWinnerScal3(displayXO_1Array) == 'O') {
          displayXO_1Array[i] = ''; // คืนสถานะ
          return i; // หากชนะได้ทันทีให้คืนตำแหน่งนี้
        }

        // ตรวจสอบการป้องกันการชนะของฝ่ายตรงข้าม
        displayXO_1Array[i] = 'X';
        if (_checkWinnerScal3(displayXO_1Array) == 'X') {
          displayXO_1Array[i] = ''; // คืนสถานะ
          return i; // หากฝ่ายตรงข้ามชนะได้ในรอบถัดไปให้ป้องกัน
        }
        displayXO_1Array[i] = ''; // คืนสถานะ

        // ใช้ Minimax Algorithm ถ้าไม่มีการชนะหรือแพ้ทันที
        int moveValue = _minimaxScal3(displayXO_1Array, depth, false);
        if (moveValue > bestValue) {
          bestMove = i;
          bestValue = moveValue;
        }
      }
    }

    return bestMove;
  }

  int _minimaxScal3(List<String> board, int depth, bool isMaximizing) {
    String winner = _checkWinnerScal3(board);
    if (winner == 'O') return 10 - depth; // ชนะ
    if (winner == 'X') return depth - 10; // แพ้
    if (!_isMovesLeft(board)) return 0; // เสมอ

    if (isMaximizing) {
      int best = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'O';
          int moveValue = _minimaxScal3(board, depth - 1, false);
          board[i] = '';
          best = max(best, moveValue);
        }
      }
      return best;
    } else {
      int best = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'X';
          int moveValue = _minimaxScal3(board, depth - 1, true);
          board[i] = '';
          best = min(best, moveValue);
        }
      }
      return best;
    }
  }

  String _checkWinnerScal3(List<String> board) {
    // ตรวจสอบแถว
    for (int i = 0; i < 3; i++) {
      if (board[i * 3] == board[i * 3 + 1] &&
          board[i * 3 + 1] == board[i * 3 + 2] &&
          board[i * 3] != '') {
        return board[i * 3];
      }
    }
    // ตรวจสอบคอลัมน์
    for (int i = 0; i < 3; i++) {
      if (board[i] == board[i + 3] &&
          board[i + 3] == board[i + 6] &&
          board[i] != '') {
        return board[i];
      }
    }
    // ตรวจสอบทแยงมุม
    if (board[0] == board[4] && board[4] == board[8] && board[0] != '') {
      return board[0];
    }
    if (board[2] == board[4] && board[4] == board[6] && board[2] != '') {
      return board[2];
    }
    return '';
  }

  bool _isMovesLeft(List<String> board) {
    return board.contains('');
  }

  bool _isBoardFull() {
    for (var i = 0; i < scal; i++) {
      for (var j = 0; j < scal; j++) {
        if (displayXO[i][j] == '') return false;
      }
    }
    return true;
  }

  int _evaluateMove(int row, int col, String symbol) {
    List<List<String>> tempBoard = List.generate(
      scal,
      (i) => List.from(displayXO[i]),
    );
    tempBoard[row][col] = symbol;

    // ประเมินคะแนนของการเคลื่อนไหว
    int score = 0;

    // ตรวจสอบการชนะ
    if (_checkForWinner(tempBoard) == symbol) {
      score += 10; // เพิ่มคะแนนหากการเคลื่อนไหวทำให้ชนะ
    }

    // เพิ่มคะแนนสำหรับการป้องกันการแพ้
    if (_willWin([row, col], symbol == 'X' ? 'O' : 'X')) {
      score += 5; // เพิ่มคะแนนถ้าการเคลื่อนไหวสามารถป้องกันการแพ้
    }
    return score;
  }

// Minimax พร้อม Alpha-Beta Pruning
  int _minimax(List<List<String>> board, int depth, bool isMaximizing,
      int alpha, int beta) {
    String winner = _checkForWinner(displayXO);
    if (winner == 'X') return -10;
    if (winner == 'O') return 10;
    if (_isBoardFull()) return 0;

    if (isMaximizing) {
      int maxEval = -double.infinity.toInt();
      for (var i = 0; i < scal; i++) {
        for (var j = 0; j < scal; j++) {
          if (board[i][j] == '') {
            board[i][j] = 'O';
            int eval = _minimax(board, depth + 1, false, alpha, beta);
            board[i][j] = '';
            maxEval = max(maxEval, eval);
            alpha = max(alpha, eval);
            if (beta <= alpha) break; // Beta cut-off
          }
        }
      }
      return maxEval;
    } else {
      int minEval = double.infinity.toInt();
      for (var i = 0; i < scal; i++) {
        for (var j = 0; j < scal; j++) {
          if (board[i][j] == '') {
            board[i][j] = 'X';
            int eval = _minimax(board, depth + 1, true, alpha, beta);
            board[i][j] = '';
            minEval = min(minEval, eval);
            beta = min(beta, eval);
            if (beta <= alpha) break; // Alpha cut-off
          }
        }
      }
      return minEval;
    }
  }

// ฟังก์ชันเลือกการเคลื่อนไหวที่ดีที่สุด
  void _chooseBestMove() {
    List<List<int>> emptyPositions = [];
    int bestScore = -2147483648;
    List<int> bestMove = [];

    // ดึงตำแหน่งที่ว่างทั้งหมด
    for (var i = 0; i < scal; i++) {
      for (var j = 0; j < scal; j++) {
        if (displayXO[i][j] == '') {
          emptyPositions.add([i, j]);
        }
      }
    }

    for (var move in emptyPositions) {
      int score = _evaluateMove(move[0], move[1], 'X');
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    // ทำการเคลื่อนไหวที่ดีที่สุด
    if (bestMove.isNotEmpty) {
      setState(() {
        displayXO[bestMove[0]][bestMove[1]] = 'X';
        filledBoxes++;
        oturn = !oturn;
      });

      _checkWinner();
    }
  }

  bool _willWin(List<int> move, String opponentSymbol) {
    List<List<String>> tempBoard = List.generate(
      scal,
      (i) => List.from(displayXO[i]),
    );
    tempBoard[move[0]][move[1]] = opponentSymbol;
    return _checkForWinner(tempBoard) == opponentSymbol;
  }

  void _aiMove() {
    _chooseBestMove();
  }

  bool _checkLine(List<String> line, List<List<int>> positions, int startRow,
      int startCol, int rowStep, int colStep,
      [String checkSymbol = 'X']) {
    String firstCell = line[0];
    if (firstCell.isEmpty || (checkSymbol != 'X' && checkSymbol != 'O')) {
      return false;
    }

    bool allMatch = true;
    for (int i = 0; i < line.length; i++) {
      if (line[i] != checkSymbol) {
        allMatch = false;
        break;
      }
    }

    if (allMatch) {
      for (int i = 0; i < line.length; i++) {
        positions.add([startRow + i * rowStep, startCol + i * colStep]);
      }
    }
    return allMatch;
  }

  String _checkForWinner(List<List<String>> board) {
    for (var i = 0; i < scal; i++) {
      if (_checkLine(board[i], [], i, 0, 0, 1, 'X')) return 'X';
      if (_checkLine(board[i], [], i, 0, 0, 1, 'O')) return 'O';
    }

    for (var j = 0; j < scal; j++) {
      List<String> column = List.generate(scal, (i) => board[i][j]);
      if (_checkLine(column, [], 0, j, 1, 0, 'X')) return 'X';
      if (_checkLine(column, [], 0, j, 1, 0, 'O')) return 'O';
    }

    List<String> diag1 = List.generate(scal, (i) => board[i][i]);
    if (_checkLine(diag1, [], 0, 0, 1, 1, 'X')) return 'X';
    if (_checkLine(diag1, [], 0, 0, 1, 1, 'O')) return 'O';

    List<String> diag2 = List.generate(scal, (i) => board[i][scal - 1 - i]);
    if (_checkLine(diag2, [], 0, scal - 1, 1, -1, 'X')) return 'X';
    if (_checkLine(diag2, [], 0, scal - 1, 1, -1, 'O')) return 'O';

    return '';
  }

  void _checkWinner() {
    winPositions = [];

    // แถว
    for (int i = 0; i < scal; i++) {
      if (_checkLine(displayXO[i], winPositions, i, 0, 0, 1, 'X') ||
          _checkLine(displayXO[i], winPositions, i, 0, 0, 1, 'O')) {
        _showWinner(displayXO[i][0]);
        return;
      }
    }

    // คอลัมน์
    for (int i = 0; i < scal; i++) {
      List<String> column = List.generate(scal, (j) => displayXO[j][i]);
      if (_checkLine(column, winPositions, 0, i, 1, 0, 'X') ||
          _checkLine(column, winPositions, 0, i, 1, 0, 'O')) {
        _showWinner(displayXO[0][i]);
        return;
      }
    }

    // แนวทแยง
    List<String> diag1 = List.generate(scal, (i) => displayXO[i][i]);
    List<String> diag2 = List.generate(scal, (i) => displayXO[i][scal - 1 - i]);

    if (_checkLine(diag1, winPositions, 0, 0, 1, 1, 'X') ||
        _checkLine(diag2, winPositions, 0, scal - 1, 1, -1, 'X') ||
        _checkLine(diag1, winPositions, 0, 0, 1, 1, 'O') ||
        _checkLine(diag2, winPositions, 0, scal - 1, 1, -1, 'O')) {
      _showWinner(diag1[0]);
      return;
    }

    // เสมอ
    if (filledBoxes == doubleScal) {
      _showWinner('');
    }
  }

  void _showWinner(String winner) {
    stopTimer(); // หยุดตัวจับเวลา
    displayXO_1Array = [];
    for (var i = 0; i < scal; i++) {
      for (var j = 0; j < scal; j++) {
        displayXO_1Array.add(displayXO[i][j]);
      }
    }

    // เพิ่มตำแหน่งการชนะลงใน winPositions_1Array
    for (var pos in winPositions) {
      winPositions_1Array.addAll(pos);
    }

    setState(() {
      gameOver = true; // ตั้งค่า gameOver เป็น true เพื่อหยุดการทำงานของ AI
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              winner.isEmpty ? 'Game Draw!' : 'Player $winner Wins!',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  // อัพเดทคะแนน
                  if (winner == 'O') {
                    oScore++;
                    addHistory('Player', displayXO_1Array, winPositions_1Array);
                  } else if (winner == 'X') {
                    xScore++;
                    addHistory('Ai', displayXO_1Array, winPositions_1Array);
                  } else {
                    addHistory('Draw', displayXO_1Array, winPositions_1Array);
                  }
                  // รีเซ็ตสถานะเกม
                  gameOver = false;
                  winPositions = [];
                  displayXO_1Array = [];
                  displayXO = List.generate(
                      scal, (i) => List.generate(scal, (j) => ''));
                  filledBoxes = 0;
                  resetTimer();
                  startTimer();
                  oturn = true;
                });
                Navigator.of(context).pop();
              },
              child: const Center(child: Text('OK')),
            ),
          ],
        );
      },
    );
  }

  void addHistory(String name, List<String> displayXO_1Array,
      List<int> winPositions_1Array) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final String formatted =
        formatter.format(now.toUtc().add(const Duration(hours: 7)));
    CollectionReference collHistoryAi =
        FirebaseFirestore.instance.collection('historyAi');
    try {
      DocumentReference newHisRef = await collHistoryAi.add({
        'win': name,
        'oScore': oScore,
        'xScore': xScore,
        'broad': displayXO_1Array,
        'date': formatted,
        'winPosition': winPositions_1Array,
        'scal': scal
      });
      String docId = newHisRef.id;
      await newHisRef.update({'id': docId});
    } catch (error) {
      print(error);
    }
  }
}
