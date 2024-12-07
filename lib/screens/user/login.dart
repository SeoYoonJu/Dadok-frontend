import 'join.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': _userIdController.text,
        'userPassword': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // 서버가 JWT를 단순 문자열로 반환한다고 가정
      final token = response.body;  // 여기서 response.body는 JWT 문자열
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('authToken', token);  // 토큰 저장

      Navigator.pushReplacementNamed(context, '/main');  // 로그인 후 메인 화면으로 이동
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 실패. 다시 시도하세요.')),
      );
    }
  }

  void _navigateToJoin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JoinScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _userIdController, decoration: const InputDecoration(labelText: '아이디')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: '비밀번호')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('로그인')),
            TextButton(onPressed: _navigateToJoin, child: const Text('회원가입')),
          ],
        ),
      ),
    );
  }
}


// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _userIdController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   Future<void> _login() async {
//     final response = await http.post(
//       Uri.parse('http://localhost:8080/login'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'userId': _userIdController.text,
//         'userPassword': _passwordController.text,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final token = data['token'];  // Assuming the response contains a 'token'
//
//       // Save the token to SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('authToken', token);
//
//       Navigator.pushReplacementNamed(context, '/main');  // Navigate to the main page
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('로그인 실패. 다시 시도하세요.')),
//       );
//     }
//   }
//
//   void _navigateToJoin() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const JoinScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('로그인')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(controller: _userIdController, decoration: const InputDecoration(labelText: '아이디')),
//             TextField(controller: _passwordController, decoration: const InputDecoration(labelText: '비밀번호')),
//             const SizedBox(height: 20),
//             ElevatedButton(onPressed: _login, child: const Text('로그인')),
//             TextButton(onPressed: _navigateToJoin, child: const Text('회원가입')),
//           ],
//         ),
//       ),
//     );
//   }
// }
