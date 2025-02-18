import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ShowBookScreen extends StatefulWidget {
  final String id;

  const ShowBookScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _ShowBookScreenState createState() => _ShowBookScreenState();
}

class _ShowBookScreenState extends State<ShowBookScreen> {
  String title = '';
  String picture = '';
  String author = '';
  String content = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookDetails();
  }

  Future<void> _fetchBookDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('authToken');

      final response = await http.get(
        Uri.parse('http://localhost:8080/book/${widget.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        if (responseData['isSuccess'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          setState(() {
            title = data['title'] ?? '';
            picture = data['picture'] ?? '';
            author = data['author'] ?? '';
            content = data['content'] ?? '';
            isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load book details: ${response.statusCode}')),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topSectionHeight = MediaQuery
        .of(context)
        .size
        .height * 0.5;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/main.png',
                        width: 150,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: topSectionHeight * 0.4,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
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
                          picture,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                author,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}