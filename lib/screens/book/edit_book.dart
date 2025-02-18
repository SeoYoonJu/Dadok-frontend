import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../main_navigation_screen.dart';

class EditBookScreen extends StatefulWidget {
  final String id;
  final String title;
  final String picture;
  final String author;
  final String content;

  EditBookScreen({
    required this.id,
    required this.title,
    required this.picture,
    required this.author,
    required this.content,
  });

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late TextEditingController _titleController;
  late TextEditingController _pictureController;
  late TextEditingController _authorController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _pictureController = TextEditingController(text: widget.picture);
    _authorController = TextEditingController(text: widget.author);
    _contentController = TextEditingController(text: widget.content);
  }

  Future<void> _updateBook() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('authToken');

    final url = Uri.parse('http://localhost:8080/book/${widget.id}');
    final body = {
      "title": _titleController.text,
      "picture": _pictureController.text,
      "author": _authorController.text,
      "content": _contentController.text,
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
        const SnackBar(content: Text('Book updated successfully!')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AppNavigator(selectedIndex: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to update book: ${response.statusCode}')),
      );
    }
  }

  Future<void> _deleteBook() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('authToken');

    final url = Uri.parse('http://localhost:8080/book/${widget.id}');

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book deleted successfully!')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AppNavigator(selectedIndex: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to delete book: ${response.statusCode}')),
      );
    }
  }

  Widget build(BuildContext context) {
    final topSectionHeight = MediaQuery
        .of(context)
        .size
        .height * 0.5;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: topSectionHeight,
            child: Stack(
              children: [
                Container(
                  height: topSectionHeight * 0.52,
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
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Image.asset(
                        'assets/images/main.png',
                        width: 150,
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: _updateBook,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF44B1F0),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              child: const Text('내글 수정'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _deleteBook,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              child: const Text('내글 삭제'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: topSectionHeight * 0.35,
                  left: 20,
                  right: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.picture,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          height: topSectionHeight * 0.55,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.author,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: '글 작성',
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

