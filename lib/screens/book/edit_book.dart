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
          builder: (context) => AppNavigator(selectedIndex: 1), // 키 없이 전달
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
          builder: (context) => AppNavigator(selectedIndex: 1), // 키 없이 전달
        ),
      ); // 삭제 후 이전 화면으로 돌아가기
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
        .height * 0.4;

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
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/main.png',
                      width: 150,
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
                      ElevatedButton(
                        onPressed: _updateBook,
                        child: const Text('Update'),
                      ),
                      ElevatedButton(
                        onPressed: _deleteBook,
                        child: const Text('Delete'),
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
                  TextField(controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title')),
                  const SizedBox(height: 8.0),
                  TextField(controller: _authorController,
                      decoration: const InputDecoration(labelText: 'Author')),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(labelText: 'Content'),
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


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Book'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Image.network(
//                     widget.picture,
//                     width: 100,
//                     height: 150,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(width: 16.0),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title')),
//                       TextField(controller: _authorController, decoration: const InputDecoration(labelText: 'Author')),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             TextField(
//               controller: _contentController,
//               decoration: const InputDecoration(labelText: 'Content'),
//               maxLines: 5,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(onPressed: _updateBook, child: const Text('Update')),
//           ],
//         ),
//       ),
//     );
//   }
// }
}