import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JoinScreen extends StatefulWidget {
  const JoinScreen({Key? key}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _favoriteController = TextEditingController();

  Future<void> _join() async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/join'),
      headers: {'Content-Type': 'application/json'}, // 토큰 없음
      body: json.encode({
        'userId': _userIdController.text,
        'userPassword': _passwordController.text,
        'username': _usernameController.text,
        'goal': int.tryParse(_goalController.text) ?? 0,
        'favorite': _favoriteController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 성공. 로그인을 진행하세요.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 실패. 다시 시도하세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _userIdController, decoration: const InputDecoration(labelText: '아이디')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: '비밀번호')),
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: '사용자 이름')),
            TextField(controller: _goalController, decoration: const InputDecoration(labelText: '목표')),
            TextField(controller: _favoriteController, decoration: const InputDecoration(labelText: '좋아하는 책')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _join, child: const Text('회원가입')),
          ],
        ),
      ),
    );
  }
}