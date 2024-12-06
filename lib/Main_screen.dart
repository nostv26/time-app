import 'package:flutter/material.dart';
import 'package:my_app_time/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Main_Screen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<Main_Screen> {
  int _remainingTime = 0;
  String memo = "";
  Timer? _timer;
  bool _isStarted = false;
  @override
  void initState() {
    super.initState();
    fetchDataOnce();
  }

  Future<void> fetchDataOnce() async {
    final db = FirebaseFirestore.instance.collection('times').doc('02');
    try {
      DocumentSnapshot documentSnapshot = await db.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        int hours = data['hour'] ?? 0;
        int minutes = data['minute'] ?? 0;
        int seconds = data['second'] ?? 0;
        String memoData = data['memo'] ?? "";

        setState(() {
          _remainingTime = (hours * 3600) + (minutes * 60) + seconds;
          memo = memoData;
        });
      } else {
        print("Tài liệu không tồn tại");
      }
    } catch (e) {
      print("Lỗi khi lấy dữ liệu: $e");
    }
  }

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

  void _resetTimer() {
    fetchDataOnce();
  }

  void _playAlarm() {
    print("Alarm! Time's up!");
  }

  void _backSettingTime() {
    print("quay lai time list");
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _updateMemo(String newMemo) async {
    final db = FirebaseFirestore.instance.collection('times').doc('02');
    try {
      await db.update({'memo': newMemo});
      setState(() {
        memo = newMemo; // Cập nhật giá trị memo trên giao diện
      });
      print("Memo updated successfully");
    } catch (e) {
      print("Error updating memo: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = _remainingTime >= 3600
        ? '${(_remainingTime ~/ 3600).toString().padLeft(2, '0')}:${((_remainingTime % 3600) ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}'
        : '${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}';
    return Scaffold(
      appBar: Header(text: 'Timer'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Vòng tròn hiển thị thời gian
            Container(
              width: 300, // Chiều rộng của vòng tròn
              height:
                  300, // Chiều cao của vòng tròn (bằng width để đảm bảo đối xứng)
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center, // Căn giữa nội dung bên trong
              child: Text(
                formattedTime,
                style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),

            // Nút Start và Stop
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _backSettingTime,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 200, 200, 200),
                    padding: EdgeInsets.all(35), // Đặt padding đều để nút tròn
                    shape: CircleBorder(), // Đặt nút tròn
                    minimumSize:
                        Size(90, 90), // Đặt kích thước cố định để nút luôn tròn
                  ),
                  child: Text(
                    "キャンセル",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      // color: Colors.black,
                    ),
                    textAlign: TextAlign.center, // Căn giữa văn bản
                  ),
                ),
                Spacer(),
                // Nút Reset
                ElevatedButton(
                  onPressed: _resetTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: EdgeInsets.all(17),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.refresh, size: 24),
                      Text(
                        "Reset",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),

                Spacer(),
                ElevatedButton(
                  onPressed: _toggleTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isStarted
                        ? Colors.orange[200]
                        : const Color.fromARGB(255, 126, 238,
                            202), // Màu xanh lá khi nút ở trạng thái "Start"
                    padding: EdgeInsets.all(35), // Đặt padding đều để nút tròn
                    shape: CircleBorder(), // Đặt nút tròn
                    minimumSize:
                        Size(90, 90), // Đặt kích thước cố định để nút luôn tròn
                  ),
                  child: Text(
                    _isStarted
                        ? "Stop"
                        : "Start", // Đổi văn bản dựa trên trạng thái
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isStarted
                          ? Colors.orange[600]
                          : const Color.fromARGB(255, 0, 91, 62),
                    ),
                    textAlign: TextAlign.center, // Căn giữa văn bản
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            // Dòng memo và khu vực text
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9.0),
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
                            controller: TextEditingController(text: memo),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: none,
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _updateMemo(value); // Lưu giá trị memo mới
                                print("Nội dung: $value");
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.black),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '再生声優:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        // Switch(
                        //   value: isSwitched, // Biến trạng thái tắt/mở
                        //   onChanged: (value) {
                        //     setState(() {
                        //       isSwitched = value; // Cập nhật trạng thái
                        //     });
                        //   },
                        //   activeColor: Colors.brown, // Màu khi bật
                        //   inactiveThumbColor: Colors.black, // Màu khi tắt
                        //   inactiveTrackColor: Colors.grey, // Màu nền khi tắt
                        // ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.black),
                  // Text(
                  //   '再生声優:',
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'タイマー終了:',
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
          ],
        ),
      ),
      // Bottom Navigation
    );
  }
}
