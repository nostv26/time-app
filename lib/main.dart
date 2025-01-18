import 'package:flutter/material.dart';
import 'package:my_app_time/List_time.dart';
import 'package:my_app_time/Timer_picker.dart';
import 'package:my_app_time/basepage.dart';
import 'package:my_app_time/header.dart';
import 'package:my_app_time/test1.dart';
// import 'List_time.dart';
import 'Time_screen.dart';
import 'time_fix.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Tệp cấu hình Firebase của bạn

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: TabBarView(
            children: [
              Basepage(),
              RecentTimersScreen(),
              AlarmTimerScreen(),
            ], //hẹn giờ  ,bấm giờ và báo thức
          ),
          // ignore: prefer_const_constructors
          bottomNavigationBar: TabBar(
            tabs: const [
              Tab(
                icon: Image(
                  image: AssetImage(
                      '../assets/images/timer.png'), // Thay đường dẫn đến hình ảnh của bạn
                  width: 30,
                  height: 30,
                  // color: Colors.blue,
                ),
              ),
              Tab(
                icon: Image(
                  image: AssetImage(
                      '../assets/images/stopwatch.png'), // Thay đường dẫn đến hình ảnh của bạn
                  width: 30,
                  height: 30,
                  // color: Colors.blue,
                ),
              ),
              Tab(
                icon: Image(
                  image: AssetImage(
                      '../assets/images/alarm.png'), // Thay đường dẫn đến hình ảnh của bạn
                  width: 30,
                  height: 30,
                  // color: Colors.blue,
                ),
              ),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:my_app_time/dashbroad.dart';
// import 'header.dart';
// import 'dashbroad.dart';
// import 'List_time.dart';

// void main() => runApp(const Tab_Bar());

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: Tab_Bar(),
// //     );
// //   }
// // }

// // ignore: camel_case_types
// class Tab_Bar extends StatelessWidget {
//   const Tab_Bar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: DefaultTabController(
//           length: 3,
//           child: Scaffold(
//             appBar: Header(),

//             // appBar: AppBar(
//             //   bottom: const TabBar(
//             //     tabs: [
//             //       Tab(icon: Icon(Icons.directions_car)),
//             //       Tab(icon: Icon(Icons.directions_transit)),
//             //       Tab(icon: Icon(Icons.directions_bike)),
//             //     ],
//             //   ),
//             //   title: const Text('Tabs Demo'),
//             // ),
//             bottomNavigationBar: AppBar(
//               bottom: const TabBar(
//                 tabs: [
//                   Tab(icon: Icon(Icons.directions_car)),
//                   Tab(icon: Icon(Icons.directions_transit)),
//                   Tab(icon: Icon(Icons.directions_bike)),
//                 ],
//               ),
//               title: const Text('Tabs Demo'),
//             ),
//             body: const TabBarView(
//               children: [
//                 Icon(Icons.directions_car),
//                 Icon(Icons.directions_transit),
//                 Icon(Icons.directions_bike),
//               ],
//             ),
//           ),
//         ));
//   }
// }
