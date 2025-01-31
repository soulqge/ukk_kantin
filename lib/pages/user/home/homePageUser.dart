import 'package:flutter/material.dart';
import 'package:ukk_kantin/components/navbar_user.dart';
import 'package:ukk_kantin/pages/user/history/history_page_content.dart';
import 'package:ukk_kantin/pages/user/home/home_page_content.dart';
// import 'package:ukk_kantin/pages/user-home/profile_page_content.dart';

class Homepageuser extends StatefulWidget {
  const Homepageuser({super.key});

  @override
  State<Homepageuser> createState() => _HomepageuserState();
}

class _HomepageuserState extends State<Homepageuser> {
  final PageController _pageController = PageController(initialPage: 0);

  int _currentPage = 0;

  void onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: const [
            HomePageContent(),
            HistoryPageContent(),
            // ProfilePageContent(),
          ],
        ),
        bottomNavigationBar: BottomNavUser(
          selectedItem: _currentPage,
          onItemTapped: onItemTapped,
        ),
      ),
    );
  }
}
