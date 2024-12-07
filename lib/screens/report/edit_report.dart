import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../main_navigation_screen.dart';

class EditReportScreen extends StatefulWidget {
  final String id;
  final String title;
  final String content;

  const EditReportScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  _EditReportScreenState createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
  }

  Future<void> _updateReport() async {
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 내용을 모두 입력해주세요')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('authToken');

      if (token == null) throw Exception('토큰이 없습니다');

      final url = Uri.parse('http://localhost:8080/report/${widget.id}');
      final body = {
        "title": _titleController.text.trim(),
        "content": _contentController.text.trim(),
      };

      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('독후감이 수정되었습니다')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AppNavigator(selectedIndex: 3),
          ),
        );
      } else {
        throw Exception('Failed to update report');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('독후감 수정에 실패했습니다')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteReport() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('authToken');

      if (token == null) throw Exception('토큰이 없습니다');

      final url = Uri.parse('http://localhost:8080/report/${widget.id}');

      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('독후감이 삭제되었습니다')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AppNavigator(selectedIndex: 3),
          ),
        );
      } else {
        throw Exception('Failed to delete report');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('독후감 삭제에 실패했습니다')),
      );
    } finally {
      setState(() => _isLoading = false);
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
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _updateReport,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF44B1F0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          )
                              : const Text('수정하기'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _deleteReport,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('삭제하기'),
                        ),
                      ),
                    ],
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: '내용',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignLabelWithHint: true,
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
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

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}