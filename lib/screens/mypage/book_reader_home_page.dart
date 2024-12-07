import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../report/edit_report.dart';
import '../report/report_list_screen.dart';

class BookReaderHomePage extends StatefulWidget {
  const BookReaderHomePage({Key? key}) : super(key: key);

  @override
  _BookReaderHomePageState createState() => _BookReaderHomePageState();
}

class _BookReaderHomePageState extends State<BookReaderHomePage> {
  // Profile Data
  String username = '';
  int goal = 0;
  String favorite = '';
  bool isLoading = true;
  List<Report> reports = [];

  Future<void> _fetchReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('authToken');

      if (token == null) {
        print('No token found');
        return;
      }

      final response = await http.get(
        Uri.parse('http://localhost:8080/report/all'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(
            utf8.decode(response.bodyBytes));

        if (responseData['isSuccess'] == true && responseData['data'] != null) {
          final List<dynamic> reportList = responseData['data'] as List<dynamic>;
          setState(() {
            reports = reportList.map((data) => Report.fromJson(data)).toList().reversed.toList();
          });
        }
      }
    } catch (e) {
      print('Error fetching reports: $e');
    }
  }

  Future<void> _fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('authToken');

    if (token == null) {
      print('No token found, please log in');
      return;
    }

    final response = await http.get(
      Uri.parse('http://localhost:8080/mypage/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = json.decode(responseBody);
      if (data['isSuccess'] == true) {
        setState(() {
          username = data['data']['username'];
          goal = data['data']['goal'];
          favorite = data['data']['favorite'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
    _fetchReports();
  }

  Widget _buildRecentReports() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '나의 최근 독후감',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        reports.isEmpty
            ? const Center(
          child: Text(
            '작성된 독후감이 없습니다',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        )
            : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reports.length > 3 ? 3 : reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditReportScreen(
                            id: report.id.toString(),
                            title: report.title,
                            content: report.content,
                          ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(
                    report.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    report.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const double topSectionHeight = 280;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              SizedBox(
                height: topSectionHeight,
                child: Stack(
                  children: [
                    Container(
                      height: topSectionHeight * 0.65,
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
                    ),
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
                      top: topSectionHeight * 0.4,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey[300],
                                  child: const Icon(Icons.person, size: 40),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    isLoading
                                        ? const CircularProgressIndicator()
                                        : Text(
                                      username,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    isLoading
                                        ? const SizedBox.shrink()
                                        : Text('목표 독후감 수: $goal'),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            isLoading
                                ? const CircularProgressIndicator()
                                : Text('가장 좋아하는 도서: $favorite'),
                            const SizedBox(height: 8),
                            isLoading
                                ? const SizedBox.shrink()
                                : LinearProgressIndicator(
                              value: goal / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                            ),
                            const SizedBox(height: 4),
                            isLoading
                                ? const SizedBox.shrink()
                                : Text('$goal% 달성'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150,
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/images/book.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: _buildRecentReports(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
