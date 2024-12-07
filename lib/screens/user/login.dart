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
      final token = response.body;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('authToken', token);

      Navigator.pushReplacementNamed(context, '/main');
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
                          '로그인',
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
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildTextField(_userIdController, '아이디를 입력해주세요'),
                      const SizedBox(height: 16),
                      _buildTextField(_passwordController, '비밀번호를 입력해주세요',
                          isPassword: true),
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
                          onPressed: _login,
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
                            '로그인',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: _navigateToJoin,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                        ),
                        child: const Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
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