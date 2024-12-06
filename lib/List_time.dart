import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:my_app_time/header.dart';
import 'package:my_app_time/main.dart';

class ListTime extends StatefulWidget {
  @override
  _ListTimeState createState() => _ListTimeState();
}

class _ListTimeState extends State<ListTime> {
  bool isStartImage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(text: 'Timer'),
      body: Center(
        child: Container(
          width: double.infinity,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // StreamBuilder để kết nối Firestore
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('times')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              print('Đã có lỗi xảy ra');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Xử lý sự kiện khi nhấn vào nút "修正"
                                    print("修正 button clicked");
                                  },
                                  child: Text(
                                    '修正',
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Spacer(), //
                                Text(
                                  'Time',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                                Spacer(),
                              ],
                            );
                            // Lấy danh sách dữ liệu từ snapshot
                            final dataDocs = snapshot.data!.docs;

                            return Column(
                              children: dataDocs.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                return buildTimeCard(
                                  context,
                                  data['time'] ?? '00:00',
                                  data['memo'] ?? 'Không có ghi chú',
                                  const Color(0xFFA97100),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTimeCard(
      BuildContext context, Timestamp time, String memo, Color color) {
    String formattedTime = DateFormat('HH:mm').format(time.toDate());
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Xử lý sự kiện khi nhấn vào nút "修正"
                    print("修正 button clicked");
                  },
                  child: Text(
                    '修正',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(), //

                Spacer(),
              ],
            ),
            Row(
              children: [
                Text(
                  formattedTime,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    print("click");
                    // Thay đổi trạng thái khi nhấn vào hình ảnh
                    setState(() {
                      isStartImage = !isStartImage;
                    });
                  },
                  child: Image.asset(
                    isStartImage
                        ? '../assets/images/timer_start.png'
                        : '../assets/images/timer_pause.png',
                    width: 60,
                    height: 60,
                    color: color,
                  ),
                )
              ],
            ),
            SizedBox(height: 8),
            Text(
              memo,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
