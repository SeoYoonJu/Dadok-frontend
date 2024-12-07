import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main_navigation_screen.dart';

class WriteReportPage extends StatefulWidget {
  const WriteReportPage({Key? key}) : super(key: key);

  @override
  _WriteReportPageState createState() => _WriteReportPageState();
}

class _WriteReportPageState extends State<WriteReportPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitReport() async {
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 내용을 모두 입력해주세요')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('authToken');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인이 필요합니다')),
        );
        return;
      }

      final reportData = {
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
      };

      final response = await http.post(
        Uri.parse('http://localhost:8080/report'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(reportData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AppNavigator(selectedIndex: 3),
          ),
        );
      } else {
        throw Exception('Failed to create report');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('독후감 작성에 실패했습니다')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final topSectionHeight = MediaQuery.of(context).size.height * 0.25;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: topSectionHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF44B1F0),
                  Color(0xFF874FFF),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                // Header
                Positioned(
                  top: 30,
                  left: 30,
                  right: 30,
                  child: Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        final appNavigatorState = context.findAncestorStateOfType<AppNavigatorState>();
                        appNavigatorState?.navigateToHome();
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/sub.png',
                            width: 100,
                          ),
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 24),
                              child: Text(
                                '다양한 독서활동을 모아보자',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Submit Button
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF44B1F0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        '작성하기',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: '제목',
                      hintText: '책 제목을 입력하세요',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF44B1F0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: '내용',
                        hintText: '독후감 내용을 입력하세요',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF44B1F0)),
                        ),
                        alignLabelWithHint: true,
                      ),
                      expands: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}