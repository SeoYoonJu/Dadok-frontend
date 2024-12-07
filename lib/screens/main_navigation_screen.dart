import 'package:flutter/material.dart';
import 'package:untitled2/screens/book/write_book.dart';
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
  //int _selectedIndex = 2; // 기본적으로 'BookReaderHomePage'가 선택된 상태로 시작
  //bool _shouldRefreshBookList = false;

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
      const Center(child: Text('나의 독후감')),
      const Center(child: Text('마이 페이지')),
    ];
  }

  // BottomNavigationBar에서 항목을 탭했을 때 호출되는 함수
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 탭한 인덱스 화면을 선택
    });
  }

  void navigateToScreenWithRefresh(int index) {
    setState(() {
      _selectedIndex = index;
      _screens[1] = BookListScreen(
        key: UniqueKey(), // 강제로 새로고침
        onRefresh: () {},
      );
    });
  }

  // 앱 내에서 다른 페이지로 이동할 때 BottomNavigationBar가 계속 보이도록 하는 함수
  void navigateToScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void navigateToHome() {
    setState(() {
      _selectedIndex = 2; // 홈 화면(BookReaderHomePage) 인덱스로 전환
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // 현재 선택된 화면 인덱스
        children: _screens,    // 화면 리스트
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex, // 현재 선택된 인덱스
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },// 탭할 때 호출될 함수
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/ph_pen-nib.png',  // 아이콘 이미지
              width: 24, // 아이콘 크기
            ),
            label: '오늘의 필사',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/cil_book.png',  // 아이콘 이미지
              width: 24, // 아이콘 크기
            ),
            label: '책소통 광장',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/cil_book.png',  // 아이콘 이미지
              width: 24, // 아이콘 크기
            ),
            label: '홈 화면',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/cil_description.png',  // 아이콘 이미지
              width: 24, // 아이콘 크기
            ),
            label: '나의 독후감',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/carbon_chat.png',  // 아이콘 이미지
              width: 24, // 아이콘 크기
            ),
            label: '작가님 채팅',
          ),
        ],
      ),
    );
  }
}