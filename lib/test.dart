import 'package:flutter/material.dart';

class ImageSwitchScreen extends StatefulWidget {
  @override
  _ImageSwitchScreenState createState() => _ImageSwitchScreenState();
}

class _ImageSwitchScreenState extends State<ImageSwitchScreen> {
  // Biến để theo dõi trạng thái của hình ảnh
  bool isImageStart = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Switch Demo'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Thay đổi trạng thái hình ảnh khi nhấn vào
            setState(() {
              isImageStart = !isImageStart;
            });
          },
          child: Image.asset(
            // Hiển thị hình ảnh dựa trên trạng thái
            isImageStart
                ? 'assets/images/timer_start.png'
                : 'assets/images/timer_pause.png',
            width: 60,
            height: 60,
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: ImageSwitchScreen()));
