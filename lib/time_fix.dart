import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmTimerScreen extends StatefulWidget {
  @override
  _AlarmTimerScreenState createState() => _AlarmTimerScreenState();
}

class _AlarmTimerScreenState extends State<AlarmTimerScreen> {
  int _remainingTime = 0;
  Timer? _timer;

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

        print(hours);
        // Chuyển đổi `minutes` và `seconds` thành tổng số giây
        setState(() {
          _remainingTime = (minutes * 60) + seconds;
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

    // Khởi động bộ đếm thời gian
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

  void _resetTimer() {
    fetchDataOnce(); // Đặt lại giá trị từ Firebase khi nhấn Reset
  }

  void _playAlarm() {
    print("Alarm! Time's up!");
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: Text('Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$minutes:$seconds',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 249, 216, 27),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "Start",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _stopTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "Stop",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
