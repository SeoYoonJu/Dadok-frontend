import 'package:flutter/material.dart';
import 'screens/mypage/book_reader_home_page.dart';
import 'screens/book/book_list_screen.dart';
import 'screens/user/login.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const MyApp());
}
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '독후감 앱',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/login', // Initially load login screen
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/main': (context) => const AppNavigator(),
//         // Add other routes here
//       },
//     );
//   }
// }
final GlobalKey<AppNavigatorState> appNavigatorKey = GlobalKey<AppNavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '독후감 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // Initially load login screen
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => AppNavigator(key: appNavigatorKey), // GlobalKey 전달
        // Add other routes here
      },
    );
  }
}


//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '독후감 앱',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       debugShowCheckedModeBanner: false,
//
//       initialRoute: '/login',
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/main': (context) => const MainNavigationScreen(),
//       },
//     );
//   }
// }
