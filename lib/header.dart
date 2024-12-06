// custom_app_bar.dart
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String text; // Biến `text` được truyền vào trong hàm khởi tạo

  // Hàm khởi tạo cho phép truyền giá trị `text`
  Header({required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // Xử lý sự kiện khi nhấn vào nút "修正"
              print("修正 button clicked");
            },
            child: Text(
              "", // Hiển thị `text` truyền vào thay vì "修正"
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Spacer(),
          Text(
            text,
            style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold),
          ),
          Spacer(),
        ],
      ),
      centerTitle: false,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            // Xử lý khi nhấn nút Icon
            print("Icon button clicked");
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
