import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app_time/List_time.dart';
import 'package:my_app_time/Time_screen.dart';
import 'package:my_app_time/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> saveTimerToFirestore(
    int hour, int minute, int second, String voice, String description) async {
  try {
    // Tham chiếu đến bộ sưu tập "timers"
    CollectionReference timersCollection =
        FirebaseFirestore.instance.collection('timers');
    if (description.isEmpty) {
      description =
          "${hour.toString().padLeft(2, '0')} 時, ${minute.toString().padLeft(2, '0')} 分, ${second.toString().padLeft(2, '0')} 秒";
    }
    // Thêm tài liệu mới và lấy DocumentReference
    DocumentReference docRef = await timersCollection.add({
      "hour": hour,
      "minute": minute,
      "second": second,
      "description": description,
      "voice": voice,
      "createdAt": FieldValue.serverTimestamp(),
    });

    String documentId = docRef.id; // Lấy ID của tài liệu mới
    print("Dữ liệu đã được lưu lên Firestore với ID: $documentId");
    return documentId; // Trả về ID
  } catch (e) {
    print("Lỗi khi lưu dữ liệu: $e");
    throw e; // Ném lỗi để xử lý phía trên nếu cần
  }
}

class TimePickerScreen extends StatefulWidget {
  @override
  _TimePickerScreenState createState() => _TimePickerScreenState();
}

class _TimePickerScreenState extends State<TimePickerScreen> {
  int selectedHour = 0;
  int selectedMinute = 0;
  int selectedSecond = 0;
  bool isSwitched = false;
  String SelectVoice = "Eris";
  int _remainingTime = 0;
  String memo = "";
  Timer? _timer;
  Timestamp? time;
  bool _isStarted = false;

  // Tạo danh sách timers để hiển thị "最近の項目"
  List<Map<String, dynamic>> timers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(text: "Time"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề "Time Picker"
            Text(
              'Time Picker',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),

            // Picker chọn giờ, phút, giây
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildCupertinoPicker("時", 24, (value) {
                  setState(() {
                    selectedHour = value;
                  });
                }),
                buildCupertinoPicker("分", 60, (value) {
                  setState(() {
                    selectedMinute = value;
                  });
                }),
                buildCupertinoPicker("秒", 60, (value) {
                  setState(() {
                    selectedSecond = value;
                  });
                }),
              ],
            ),
            SizedBox(height: 20),

            // Nút và Text hiển thị thời gian đã chọn
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCircleButton("キャンセル", Colors.grey, () {
                  print("キャンセル clicked");
                }),
                Container(
                  width: 150,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${selectedHour.toString().padLeft(2, '0')} 時, ${selectedMinute.toString().padLeft(2, '0')} 分, ${selectedSecond.toString().padLeft(2, '0')} 秒",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                buildCircleButton("スタート", Colors.green, () async {
                  // Lưu dữ liệu vào Firestore
                  String documentId = await saveTimerToFirestore(selectedHour,
                      selectedMinute, selectedMinute, SelectVoice, memo);
                  // addTimer(formattedTime, "タイマーを設定しました");
                  print('Document ID: $documentId');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ListTime(documentId: documentId, isStarted: true),
                    ),
                  );
                  print(
                      "Bắt đầu: $selectedHour 時, $selectedMinute 分, $selectedSecond 秒");
                }),
              ],
            ),
            SizedBox(height: 30),
            buildSettingsContainer(),
            SizedBox(height: 20),

            // Nút thời gian đặt trước
            Text(
              '先に予約',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildPresetButton("1m", () {
                  setState(() {
                    selectedMinute = 1;
                    selectedHour = 0;
                    selectedSecond = 0;
                  });
                }),
                buildPresetButton("5m", () {
                  setState(() {
                    selectedMinute = 5;
                    selectedHour = 0;
                    selectedSecond = 0;
                  });
                }),
                buildPresetButton("10m", () {
                  setState(() {
                    selectedMinute = 10;
                    selectedHour = 0;
                    selectedSecond = 0;
                  });
                }),
              ],
            ),
            SizedBox(height: 20),

            // Danh sách "最近の項目"
            Text(
              '最近の項目',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            Divider(),
            SizedBox(height: 10),
            ...timers.map((timer) {
              String hour = (timer["hour"] ?? "0").toString();
              String minute =
                  ((timer["minute"] ?? 0) as int).toString().padLeft(2, '0');
              String second =
                  ((timer["second"] ?? 0) as int).toString().padLeft(2, '0');
              String description = timer["description"] ?? "No description";
              String docID = timer["id"];

              return buildTimerListItem(
                  hour, minute, second, description, docID);
            }).toList(),
            // ListView(
            //   shrinkWrap: true,
            //   prototypeItem: buildTimerListItem(),
            // ),
          ],
        ),
      ),
    );
  }

  void addTimer(String time, String description) {
    setState(() {
      timers.insert(0, {"time": time, "description": description});
    });
  }

  // Widget helper: Cupertino Picker
  Widget buildCupertinoPicker(
      String label, int count, ValueChanged<int> onChange) {
    return SizedBox(
      height: 150,
      width: 100,
      child: CupertinoPicker(
        itemExtent: 30,
        onSelectedItemChanged: onChange,
        children: List.generate(count, (index) {
          return Center(
            child: Text(
              "$index $label",
              style: TextStyle(fontSize: 20),
            ),
          );
        }),
      ),
    );
  }

  // Widget helper: Circle Button
  Widget buildCircleButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.all(30),
        shape: CircleBorder(),
        minimumSize: Size(90, 90),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildSettingsContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          buildSettingsRow(
            'メモ',
            Expanded(
              child: TextField(
                controller: TextEditingController(text: memo),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Text',
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    memo = value; // Lưu giá trị memo mới
                    print("Nội dung: $memo");
                  }
                },
              ),
            ),
          ),
          Divider(color: Colors.black),
          buildSettingsRow(
            '音声再生',
            Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                });
              },
              activeColor: Colors.brown,
              inactiveThumbColor: Colors.black,
            ),
          ),
          if (isSwitched)
            GestureDetector(
              onTap: () {
                // Hiển thị modal
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      height: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "音声声優を選択",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(color: Colors.grey),
                          ...['Anna', 'Eris', 'John'].map((voice) => ListTile(
                                title: Text(voice),
                                onTap: () {
                                  setState(() {
                                    SelectVoice = voice; // Cập nhật trực tiếp
                                    print(voice);
                                  });
                                  Navigator.pop(context); // Đóng modal
                                },
                              )),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text(
                textAlign: TextAlign.end,
                SelectVoice,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          Divider(color: Colors.black),
          buildSettingsRow('繰り返し', Text('あり', style: TextStyle(fontSize: 18))),
          Divider(color: Colors.black),
        ],
      ),
    );
  }

  // Widget helper: Settings Row
  Widget buildSettingsRow(String label, Widget trailing) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing,
        ],
      ),
    );
  }

  //get data from database
  Future<void> fetchRecentData() async {
    final db = FirebaseFirestore.instance.collection('timers');
    try {
      // Lấy 6 tài liệu gần đây, sắp xếp theo `timestamp`2
      QuerySnapshot querySnapshot = await db
          .orderBy('createdAt', descending: true) // Sắp xếp giảm dần
          .limit(6) // Lấy tối đa 6 tài liệu
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> recentData = [];

        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          recentData.add(data); // Thêm dữ liệu vào danh sách
        }
        setState(() {
          timers = recentData;
        });
      } else {
        print("Không có tài liệu nào trong collection 'timers'");
      }
    } catch (e) {
      print("Lỗi khi lấy dữ liệu: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRecentData();
  }

  // Widget helper: Timer List Item
  Widget buildTimerListItem(String hour, String minute, String second,
      String description, String docID) {
    return InkWell(
      // padding: EdgeInsets.symmetric(vertical: 8.0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListTime(
                documentId: docID,
                isStarted: true), // Thay thế bằng màn hình của bạn
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
              backgroundColor: const Color.fromARGB(255, 23, 100, 54),
              padding: EdgeInsets.all(15),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListTime(
                      documentId: docID,
                      isStarted:
                          true), // Thay TimeScreen bằng màn hình bạn muốn chuyển tới
                ),
              );
            },
            child: Icon(Icons.play_arrow,
                color: const Color.fromARGB(255, 74, 227, 130)),
          ),
          // SizedBox(height: 10),
        ],
      ),
    );
  }

  // Widget helper: Preset Button
  Widget buildPresetButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(label),
    );
  }
}
