import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app_time/Time_screen.dart';
import 'package:my_app_time/header.dart';
import 'dart:async';

class ListTime extends StatefulWidget {
  @override
  _ListTimeState createState() => _ListTimeState();
  final String documentId;
  final bool isStarted; // Trạng thái bắt đầu

  ListTime({required this.documentId, required this.isStarted});
}

class _ListTimeState extends State<ListTime> {
  late bool _isStarted = widget.isStarted;
  int _remainingTime = 0;
  String memo = "";
  Timestamp? time;
  Timer? _timer;
  List<Map<String, dynamic>> timers = [];
  @override
  void initState() {
    super.initState();
    fetchDataOnce();
  }

  Future<void> fetchDataOnce() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('timers')
        .doc(widget.documentId)
        .get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      setState(() {
        memo = data["description"] ?? ""; // Lấy giá trị "description"
        time = data["createdAt"]; // Lấy giá trị thời gian nếu có
        _remainingTime = (data["hour"] ?? 0) * 3600 +
            (data["minute"] ?? 0) * 60 +
            (data["second"] ?? 0); // Tính thời gian còn lại
      });
      // setState(() {
      //   _remainingTime = (hours * 3600) + (minutes * 60) + seconds;
      //   memo = memoDa;
      //   time = times;
      // });
      print(_isStarted);
      if (widget.isStarted) {
        _startTimer();
      }
      final db = FirebaseFirestore.instance.collection('timers');
      try {
        // Lấy 6 tài liệu gần đây, sắp xếp theo `timestamp`2
        QuerySnapshot querySnapshot = await db
            .orderBy('createdAt', descending: true) // Sắp xếp giảm dần
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          List<Map<String, dynamic>> recentData = [];

          for (var doc in querySnapshot.docs) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            recentData.add(data); // Thêm dữ liệu vào danh sách
          }
          setState(() {
            //   memo = recentData.hour;
            // time = times;
            timers = recentData;
          });
        } else {
          print("Không có tài liệu nào trong collection 'timers'");
        }
      } catch (e) {
        print("Lỗi khi lấy dữ liệu: $e");
      }
    } else {
      print("Document does not exist");
    }
  }

  void _startTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() => _isStarted = true);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _playAlarm();
        }
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() => _isStarted = false);
  }

  void _playAlarm() {
    print("Alarm triggered!");
  }

  void _delete(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('times')
          .doc(documentId)
          .delete();
      print("Document deleted: $documentId");
    } catch (e) {
      print("Error deleting document: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(text: 'Timer'),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Timer Section
          Text(
            'タイマー',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          Divider(),
          buildTimeCard(
            context,
            time ?? Timestamp.now(),
            memo,
            const Color(0xFFA97100),
          ),
          SizedBox(height: 20),

          // Recent Timers Section
          Text(
            '最近の項目',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          Divider(),
          ...timers.map((timer) {
            String hour = (timer["hour"] ?? "0").toString();
            String minute =
                ((timer["minute"] ?? 0) as int).toString().padLeft(2, '0');
            String second =
                ((timer["second"] ?? 0) as int).toString().padLeft(2, '0');
            String description = timer["description"] ?? "No description";

            return buildTimerListItem(hour, minute, second, description);
          }).toList(),
        ],
      ),
    );
  }

  Widget buildTimeCard(
      BuildContext context, Timestamp time, String memo, Color color) {
    String formattedTime = _remainingTime >= 3600
        ? '${((_remainingTime ~/ 3600) == 0 ? 0 : (_remainingTime ~/ 3600)).toString().padLeft(2, '0')}:${((_remainingTime % 3600) ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}'
        : '0:${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Time_Screen(
              documentId: widget.documentId,
              isStarted: true,
              amount: _remainingTime,
            ), // Thay thế bằng màn hình của bạn
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedTime,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                memo,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: _isStarted ? Colors.orange : Colors.green,
              padding: EdgeInsets.all(15),
            ),
            onPressed: () {
              _isStarted ? _stopTimer() : _startTimer();
            },
            child: Icon(
              _isStarted ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimerListItem(
      String hour, String minute, String second, String description) {
    return InkWell(
      // padding: EdgeInsets.symmetric(vertical: 8.0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Time_Screen(
              documentId: widget.documentId,
              isStarted: true,
              amount: _remainingTime,
            ), // Thay thế bằng màn hình của bạn
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$hour:$minute:$second',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Colors.green,
              padding: EdgeInsets.all(15),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Time_Screen(
                    documentId: widget.documentId,
                    isStarted: true,
                    amount: _remainingTime,
                  ), // Thay thế bằng màn hình của bạn
                ),
              );
            },
            child: Icon(Icons.play_arrow, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
