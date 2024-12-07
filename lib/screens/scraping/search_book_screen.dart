import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../book/write_book.dart';
import '../main_navigation_screen.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _searchBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('authToken'); // Retrieve saved token

    if (token == null) {
      // If there's no token, display a message or handle it
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to search.')),
      );
      return;
    }

    final query = _searchController.text.trim();
    if (query.isEmpty) {
      // Show a message if the query is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a search query.')),
      );
      return;
    }

    final response = await http.get(
      Uri.parse('http://localhost:8080/scrape-products/$query'),
      headers: {'Authorization': 'Bearer $token'},
    );


    if (response.statusCode == 200) {
      setState(() {
        final responseBody = utf8.decode(response.bodyBytes);
        _searchResults = List<Map<String, dynamic>>.from(json.decode(responseBody));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed. Status code: ${response.statusCode}')),
      );
    }
  }



  void _goToWritePage(Map<String, dynamic> book) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => WritePage(
    //       title: book['title'],
    //       picture: book['img_url'],
    //     ),
    //   ),
    // );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => WritePage( title: book['title'],
             picture: book['img_url'],)),
          (route) => false, // Removes all previous routes
    );
       }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search books',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _searchBooks(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _searchBooks,
            ),
          ],
        ),
      ),
      body: (_searchResults.isNotEmpty)
          ? GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final book = _searchResults[index];
          return GestureDetector(
            onTap: () => _goToWritePage(book), // 클릭 시 WritePage로 이동
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        book['img_url'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      )
          : const Center(
        child: Text('Search for books'),
      ),
    );
  }
}