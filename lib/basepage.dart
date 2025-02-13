import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app_time/Timer_picker.dart';
import 'Time_screen.dart';
import 'time_fix.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Tệp cấu hình Firebase của bạn

class Basepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TimePickerScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Tab hiện tại
  bool _isSubScreenVisible = false; // Kiểm tra SubScreen có hiển thị không

  final List<Widget> _tabs = [
    HomeTab(),
    HomeTab(),
    SearchTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hiển thị tab chính
          _tabs[_currentIndex],

          // Hiển thị SubScreen dưới dạng overlay nếu cần
          if (_isSubScreenVisible)
            Positioned.fill(
              child: SubScreen(
                onClose: () {
                  setState(() {
                    _isSubScreenVisible = false; // Đóng SubScreen
                  });
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _isSubScreenVisible = false; // Đóng SubScreen khi chuyển tab
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Hiển thị SubScreen
          final mainState = context.findAncestorStateOfType<_MainScreenState>();
          if (mainState != null) {
            mainState.setState(() {
              mainState._isSubScreenVisible = true;
            });
          }
        },
        child: Text('Go to SubScreen'),
      ),
    );
  }
}

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Search Tab'),
    );
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Tab'),
    );
  }
}

class SubScreen extends StatelessWidget {
  final VoidCallback onClose;

  const SubScreen({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'This is SubScreen',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onClose,
            child: Text('Back to Tab'),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:my_app_time/Time_screen.dart';
// import 'package:my_app_time/Timer_picker.dart';
// import 'package:my_app_time/test1.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MainScreen(),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;

//   final List<GlobalKey<NavigatorState>> _navigatorKeys = [
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//   ];

//   final List<Widget> _screens = [
//     Time_Screen(),
//     MyApp2(),
//     TimePickerScreen(),
//   ];

//   void _selectTab(int index) {
//     if (_currentIndex == index) {
//       // 同じタブをクリックしたら最初の画面に戻る
//       _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
//     } else {
//       setState(() {
//         _currentIndex = index;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: _screens.asMap().entries.map((entry) {
//           int index = entry.key;
//           Widget screen = entry.value;

//           return Offstage(
//             offstage: _currentIndex != index,
//             child: Navigator(
//               key: _navigatorKeys[index],
//               onGenerateRoute: (routeSettings) {
//                 return MaterialPageRoute(
//                   builder: (context) => screen,
//                 );
//               },
//             ),
//           );
//         }).toList(),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _selectTab,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Image(
//               image: AssetImage(
//                   '../assets/images/timer.png'), // Thay đường dẫn đến hình ảnh của bạn
//               width: 30,
//               height: 30,
//               // color: Colors.blue,
//             ),
//           ),
//           BottomNavigationBarItem(
//             icon: Image(
//               image: AssetImage(
//                   '../assets/images/stopwatch.png'), // Thay đường dẫn đến hình ảnh của bạn
//               width: 30,
//               height: 30,
//               // color: Colors.blue,
//             ),
//           ),
//           BottomNavigationBarItem(
//             icon: Image(
//               image: AssetImage(
//                   '../assets/images/alarm.png'), // Thay đường dẫn đến hình ảnh của bạn
//               width: 30,
//               height: 30,
//               // color: olors.blue,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
