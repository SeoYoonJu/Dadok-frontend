import 'package:flutter/material.dart';
import 'package:untitled2/screens/chat/chat_screen.dart';
import 'book/book_list_screen.dart';
import 'writing/write_manuscript.dart';
import 'mypage/book_reader_home_page.dart';
import 'report/report_list_screen.dart';

final GlobalKey<AppNavigatorState> appNavigatorKey = GlobalKey<AppNavigatorState>();

class AppNavigator extends StatefulWidget {
  final int selectedIndex;
  const AppNavigator({Key? key,this.selectedIndex = 2}) : super(key: key);

  @override
  State<AppNavigator> createState() => AppNavigatorState();
}

class AppNavigatorState extends State<AppNavigator> {
  late int _selectedIndex;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _screens = [
      const WriteManuscriptPage(),
      BookListScreen(
        key: UniqueKey(),
        onRefresh: () {},
      ),
      const BookReaderHomePage(),
      ReportListPage(
        key: UniqueKey(),
        onRefresh: () {},
      ),
      ChatScreen(),
      const Center(child: Text('나의 독후감')),
      const Center(child: Text('마이 페이지')),
    ];
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void navigateToScreenWithRefresh(int index) {
    setState(() {
      _selectedIndex = index;
      _screens[1] = BookListScreen(
        key: UniqueKey(),
        onRefresh: () {},
      );
    });
  }

  void navigateToScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void navigateToHome() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },// 탭할 때 호출될 함수
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/ph_pen-nib.png',
              width: 24,
            ),
            label: '오늘의 필사',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/cil_book.png',
              width: 24,
            ),
            label: '책소통 광장',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/home.png',
              width: 24,
            ),
            label: '마이 페이지',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/cil_description.png',
              width: 24,
            ),
            label: '나의 독후감',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/carbon_chat.png',
              width: 24,
            ),
            label: '작가님 채팅',
          ),
        ],
      ),
    );
  }
}