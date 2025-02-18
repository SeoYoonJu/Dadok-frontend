import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main_navigation_screen.dart';
import 'write_report.dart';
import 'edit_report.dart';

class Report {
  final int id;
  final String title;
  final String content;
  final String user;

  Report({
    required this.id,
    required this.title,
    required this.content,
    required this.user,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as int,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      user: json['user'] ?? '',
    );
  }
}

class ReportListPage extends StatefulWidget {
  final VoidCallback? onRefresh;

  const ReportListPage({Key? key, this.onRefresh}) : super(key: key);

  @override
  _ReportListPageState createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  List<Report> reports = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('authToken');

      if (token == null) {
        setState(() {
          errorMessage = '로그인이 필요합니다';
          isLoading = false;
        });
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
        final Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));

        if (responseData['isSuccess'] == true && responseData['data'] != null) {
          final List<dynamic> reportList = responseData['data'] as List<dynamic>;
          setState(() {
            reports = reportList.map((data) => Report.fromJson(data)).toList();
            isLoading = false;
            errorMessage = '';
          });
          widget.onRefresh?.call();
        } else {
          throw Exception('데이터 형식이 올바르지 않습니다');
        }
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
        errorMessage = '독후감을 불러오는데 실패했습니다';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopSection(context),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : _buildReportGrid(context),
          ),
        ],
      ),
    );
  }

  Widget _buildReportGrid(BuildContext context) {
    if (reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/main.png',
              width: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              '작성된 독후감이 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '새로운 독후감을 작성해보세요',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: fetchReports,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: reports.map((report) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditReportScreen(
                        id: report.id.toString(),
                        title: report.title,
                        content: report.content
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        report.content,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          letterSpacing: -0.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '작성자: ${report.user}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )).toList(),
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
                  padding: const EdgeInsets.only(top: 24),
                  child: const Text(
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
           MaterialPageRoute(builder: (context) => WriteReportPage()),
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
}