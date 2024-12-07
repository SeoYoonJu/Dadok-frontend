import 'package:flutter/material.dart';
import 'screens/user/login.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const MyApp());
}

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => AppNavigator(key: appNavigatorKey),
      },
    );
  }
}
