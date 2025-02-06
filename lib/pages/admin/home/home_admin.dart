import 'package:flutter/material.dart';
import 'package:ukk_kantin/components/navbar_admin.dart';
import 'package:ukk_kantin/pages/admin/home/home_admin_content.dart';
import 'package:ukk_kantin/pages/admin/menu_admin_content.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {

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
            HomeAdminContent(),
            MenuAdminContent(),
            HomeAdminContent(),
          ],
        ),
        bottomNavigationBar: BottomNavAdmin(
          selectedItem: _currentPage,
          onItemTapped: onItemTapped,
        ),
      ),
    );
  }

}