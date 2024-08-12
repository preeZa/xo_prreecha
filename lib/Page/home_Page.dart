// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xo_prreecha/Page/xo2Player_Page.dart';
import 'package:xo_prreecha/Page/xoAi_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _selectedOption = '3x3';
  final TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 350,
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // ปรับค่าตามต้องการ
                  child: Image.network(
                    'https://i.pinimg.com/564x/04/09/ba/0409ba4f866487c314996d96282037a1.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 150, // ปรับความกว้างของ Dropdown
                child: DropdownButtonFormField<String>(
                  value: _selectedOption,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: '3x3',
                      child: Text('3x3'),
                    ),
                    DropdownMenuItem(
                      value: '4x4',
                      child: Text('4x4'),
                    ),
                    DropdownMenuItem(
                      value: '5x5',
                      child: Text('5x5'),
                    ),
                    DropdownMenuItem(
                      value: '6x6',
                      child: Text('6x6'),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'OR',
                style: TextStyle(
                  color: Colors.white, // สีของข้อความ
                  fontWeight: FontWeight.bold, // ข้อความตัวหนา
                  fontSize: 18, // ขนาดของข้อความ
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 155, // ความกว้างของ TextField
                child: TextFormField(
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'กำหนดขนาดเอง',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () {
                        int number = 0;
                        if (_numberController.text != '') {
                          number = int.parse(_numberController.text);
                        } else {
                          if (_selectedOption == '3x3') {
                            number = 3;
                          } else if (_selectedOption == '4x4') {
                            number = 4;
                          }
                          else if(_selectedOption == '5x5'){
                            number = 5;
                          }else{
                            number = 6;
                          }   
                        }
          
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => XogamePage(number: number),
                          ),
                        );
                      },
                      child: const Text(
                        '2 Player',
                        style: TextStyle(
                          color: Color.fromARGB(255, 39, 39, 39), // สีของข้อความ
                          fontWeight: FontWeight.bold, // ข้อความตัวหนา
                          fontSize: 18, // ขนาดของข้อความ
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () {
                        int number = 0;
                        if (_numberController.text != '') {
                          number = int.parse(_numberController.text);
                        } else {
                          if (_selectedOption == '3x3') {
                            number = 3;
                          } else if (_selectedOption == '4x4') {
                            number = 4;
                          }
                          else if(_selectedOption == '5x5'){
                            number = 5;
                          }else{
                            number = 6;
                          }   
                        }
          
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => XoAiPage(number: number),
                          ),
                        );
                      },
                      child: const Text(
                        'Ai',
                        style: TextStyle(
                          color: Color.fromARGB(255, 39, 39, 39), // สีของข้อความ
                          fontWeight: FontWeight.bold, // ข้อความตัวหนา
                          fontSize: 18, // ขนาดของข้อความ
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
