import 'package:flutter/material.dart';

class RecentTimersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> timers = [
    {"time": "2:20:00", "description": "2時間 20分"},
    {"time": "1:20:00", "description": "1時間 20分"},
    {"time": "3:45:00", "description": "3時間 45分"},
    {"time": "0:15:00", "description": "15分"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("最近の項目", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: timers.length,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        itemBuilder: (context, index) {
          final timer = timers[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Hiển thị thời gian lớn
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timer["time"],
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      timer["description"],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                // Nút Play
                IconButton(
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.green,
                    size: 40,
                  ),
                  onPressed: () {
                    print("Start timer ${timer["time"]}");
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RecentTimersScreen(),
  ));
}
