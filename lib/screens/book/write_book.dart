import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main_navigation_screen.dart';

class WritePage extends StatefulWidget {
  final String title;
  final String picture;

  const WritePage({Key? key, required this.title, required this.picture}) : super(key: key);

  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();

  Future<void> _submitBook() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('authToken');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to submit.')),
      );
      return;
    }

    final bookData = {
      'title': widget.title,
      'picture': widget.picture,
      'author': _authorController.text.trim(),
      'content': _contentController.text.trim(),
    };

    final response = await http.post(
      Uri.parse('http://localhost:8080/book'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(bookData),
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AppNavigator(selectedIndex: 1), // 키 없이 전달
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed. Status code: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Author'),
              controller: _authorController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Content'),
              controller: _contentController,
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitBook,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
