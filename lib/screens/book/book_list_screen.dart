import 'dart:convert';
import 'package:flutter/material.dart';
import '../scraping/search_book_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_book.dart';
import '../main_navigation_screen.dart';

class BookListScreen extends StatefulWidget {
  final VoidCallback? onRefresh;

  const BookListScreen({Key? key, this.onRefresh}) : super(key: key);

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<BookData> _books = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('authToken');

      final response = await http.get(
        Uri.parse('http://localhost:8080/book/all'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final data = json.decode(responseBody);

        if (mounted) {
          setState(() {
            _books = (data['data'] as List)
                .map((book) => BookData.fromJson(book))
                .toList();
            _isLoading = false;
          });

          // 리프레시 콜백 호출
          widget.onRefresh?.call();
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'Failed to load books';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Network error occurred';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopSection(context),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : _buildBookGrid(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    const double topSectionHeight = 180.0;
    return SizedBox(
      height: topSectionHeight,
      child: Stack(
        children: [
          _buildGradientBackground(),
          _buildMainLogo(context),
          _buildCreateButton(context, topSectionHeight),
        ],
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
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
    );
  }

  Widget _buildMainLogo(BuildContext context) {
    return Positioned(
      top: 30,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () {
            // AppNavigatorState를 찾아 navigateToHome 호출
            final appNavigatorState = context.findAncestorStateOfType<AppNavigatorState>();
            appNavigatorState?.navigateToHome();
          },
          child: Image.asset(
            'assets/images/main.png',
            width: 150,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context, double topSectionHeight) {
    return Positioned(
      top: topSectionHeight * 0.65,
      left: 16,
      right: 16,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          '내 글 작성하기',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBookGrid(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditBookScreen(
                    id: book.id,
                    title: book.title,
                    picture: book.picture,
                    author: book.author,
                    content: book.content,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFEAEDFF),
                    Color(0xFFBEE2F6),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          book.picture,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Other necessary classes would be defined here
class BookData {
  final String id;
  final String title;
  final String picture;
  final String author;
  final String content;
  final String user;

  BookData({
    required this.id,
    required this.title,
    required this.picture,
    required this.author,
    required this.content,
    required this.user,
  });

  factory BookData.fromJson(Map<String, dynamic> json) {
    return BookData(
      id: json['id'].toString(),
      title: json['title'],
      picture: json['picture'],
      author: json['author'],
      content: json['content'],
      user: json['user'],
    );
  }
}