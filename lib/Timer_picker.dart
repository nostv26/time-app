import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app_time/List_time.dart';
import 'package:my_app_time/Main_screen.dart';
import 'package:my_app_time/header.dart';
import 'package:my_app_time/main.dart';

class TimePickerScreen extends StatefulWidget {
  @override
  State<TimePickerScreen> createState() => _TimePickerScreenState();
}

class _TimePickerScreenState extends State<TimePickerScreen> {
  int selectedHour = 0;
  int selectedMinute = 0;
  int selectedSecond = 0;
  bool isSwitched = false;

  int _remainingTime = 0;
  String memo = "";
  Timer? _timer;
  bool _isStarted = false;

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer!.cancel();
          _playAlarm();
        }
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void _toggleTimer() {
    setState(() {
      _isStarted = !_isStarted; // Đổi trạng thái giữa Start và Stop
    });

    if (_isStarted) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  void _playAlarm() {
    print("Alarm! Time's up!");
  }

  void _backSettingTime() {
    print("quay lai time list");
  }

  // Tạo một TextEditingController để quản lý giá trị nhập
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(text: "Setting Time"),
      body: Column(
        children: [
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft, // Đặt Text ở bên trái màn hình
            child: Text(
              'Time Picker',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 30),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Picker chọn giờ
                SizedBox(
                  height: 150, // Chiều cao toàn bộ picker
                  width: 100,
                  child: CupertinoPicker(
                    itemExtent: 30, // Chiều cao của mỗi phần tử
                    onSelectedItemChanged: (value) {
                      setState(() {
                        selectedHour = value;
                      });
                    },
                    children: List.generate(24, (index) {
                      return Center(
                        child: Text(
                          "$index 時",
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }),
                  ),
                ),
                // Picker chọn phút
                SizedBox(
                  height: 150, // Chiều cao toàn bộ picker
                  width: 100,
                  child: CupertinoPicker(
                    itemExtent: 30,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        selectedMinute = value;
                      });
                    },
                    children: List.generate(60, (index) {
                      return Center(
                        child: Text(
                          "$index 分",
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }),
                  ),
                ),
                // Picker chọn giây
                SizedBox(
                  height: 150, // Chiều cao toàn bộ picker
                  width: 100,
                  child: CupertinoPicker(
                    itemExtent: 30,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        selectedSecond = value;
                      });
                    },
                    children: List.generate(60, (index) {
                      return Center(
                        child: Text(
                          "$index 秒",
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Căn đều các nút và text
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nút "キャンセル"
              ElevatedButton(
                onPressed: _backSettingTime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 200, 200, 200),
                  padding: EdgeInsets.all(30), // Padding nhỏ hơn để cân đối hơn
                  shape: CircleBorder(), // Đặt nút tròn
                  minimumSize:
                      Size(90, 90), // Kích thước cố định để nút luôn tròn
                ),
                child: Text(
                  "キャンセル",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Hiển thị thời gian
              Container(
                width: 150, // Kích thước cố định để tránh bị giãn
                height: 40, // Đặt chiều cao hợp lý
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  "${selectedHour.toString().padLeft(2, '0')} 時, ${selectedMinute.toString().padLeft(2, '0')} 分, ${selectedSecond.toString().padLeft(2, '0')} 秒",
                  style: TextStyle(
                      fontSize: 16, color: Colors.black54), // Font size hợp lý
                  textAlign: TextAlign.center,
                ),
              ),

              // Nút "スタート"
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 231, 247, 90),
                  padding: EdgeInsets.all(30), // Padding nhỏ hơn để cân đối hơn
                  shape: CircleBorder(), // Đặt nút tròn
                  minimumSize:
                      Size(90, 90), // Kích thước cố định để nút luôn tròn
                ),
                onPressed: () {
                  // Hiển thị SubScreen
                  final mainState =
                      context.findAncestorStateOfType<_TimePickerScreenState>();
                  if (mainState != null) {
                    mainState.setState(() {
                      // mainState._isSubScreenVisible = true;
                    });
                  }
                  print(
                      "Bắt đầu: $selectedHour giờ, $selectedMinute phút, $selectedSecond giây");
                },
                child: Text(
                  "Bắt đầu",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),

          // Container(
          //   width: double.infinity,
          //   height: 30,
          //   // padding: EdgeInsets.all(10),
          //   decoration: BoxDecoration(
          //     color: Colors.grey[300],
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   alignment: Alignment.center,
          //   child: Text(
          //     "${selectedHour.toString().padLeft(2, '0')} 時, ${selectedMinute.toString().padLeft(2, '0')} 分, ${selectedSecond.toString().padLeft(2, '0')} 秒",
          //     style: TextStyle(fontSize: 18, color: Colors.black54),
          //   ),
          // ),
          SizedBox(height: 40),
          //khung select memo va ngon ngu noi
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hàng 1: Memo và Text
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'メモ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller, // Gắn TextEditingController
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                            border: InputBorder.none,

                            hintText: 'タイマー', // Gợi ý văn bản
                          ),
                          onChanged: (value) {
                            print("Nội dung: $value"); // In ra giá trị nhập
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.black),

                // Hàng 2: 音声再生 và các ô màu
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '音声再生',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: isSwitched, // Biến trạng thái tắt/mở
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value; // Cập nhật trạng thái
                          });
                        },
                        activeColor: Colors.brown, // Màu khi bật
                        inactiveThumbColor: Colors.black, // Màu khi tắt
                        inactiveTrackColor: Colors.grey, // Màu nền khi tắt
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.black),
                // Hàng 3: 繰り返し và なし
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '繰り返し',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'あり',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.black),
              ],
            ),
          ),
          SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft, // Đặt Text ở bên trái màn hình
            child: Text(
              '先に予約',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedMinute = 1;
                    selectedHour = 0;
                    selectedSecond = 0;
                  });
                  print("1m clicked");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text('1m'),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     setState(() {
              //       selectedMinute = 1;
              //       selectedHour = 0;
              //       selectedSecond = 0;
              //     });
              //     print("2m clicked");
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.grey[300],
              //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //   ),
              //   child: Text('2m'),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     setState(() {
              //       selectedMinute = 1;
              //       selectedHour = 0;
              //       selectedSecond = 0;
              //     });
              //     print("3m clicked");
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.grey[300],
              //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //   ),
              //   child: Text('3m'),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     setState(() {
              //       selectedMinute = 1;
              //       selectedHour = 0;
              //       selectedSecond = 0;
              //     });
              //     print("4m clicked");
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.grey[300],
              //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //   ),
              //   child: Text('4m'),
              // ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedMinute = 5;
                    selectedHour = 0;
                    selectedSecond = 0;
                  });
                  print("5m clicked");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text('5m'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedMinute = 10;
                    selectedHour = 0;
                    selectedSecond = 0;
                  });
                  print("10m clicked");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text('10m'),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
