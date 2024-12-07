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
      headers: {'Content-Type': 'application/json'},
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF44B1F0),
              Color(0xFF874FFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Logo and Title Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/sub.png',
                      width: 100,
                    ),
                    const SizedBox(width: 8),
                    const Padding(
                      padding: EdgeInsets.only(top: 20,left: 10),
                      child: Text(
                          '회원가입',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Form Section
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildTextField(_userIdController, '아이디를 입력해주세요'),
                        const SizedBox(height: 16),
                        _buildTextField(_passwordController, '비밀번호를 입력해주세요'),
                        const SizedBox(height: 16),
                        _buildTextField(_usernameController, '사용자 이름을 입력해주세요'),
                        const SizedBox(height: 16),
                        _buildTextField(_goalController, '목표 독서시간을 입력해주세요'),
                        const SizedBox(height: 16),
                        _buildTextField(
                            _favoriteController, '가장 좋아하는 도서를 입력해주세요'),
                        const SizedBox(height: 40),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF44B1F0),
                                Color(0xFF874FFF),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _join,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              '가입하기',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
