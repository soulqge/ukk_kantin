import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ukk_kantin/components/navbar_user.dart';
import 'package:ukk_kantin/pages/user/history/list_tran.dart';
import 'package:ukk_kantin/pages/user/home/home_page_content.dart';
import 'package:ukk_kantin/pages/user/home/profile_page_content.dart';
import 'package:ukk_kantin/pages/user/home/test.dart';
import 'package:ukk_kantin/services/api_services.dart';

class Homepageuser extends StatefulWidget {
  const Homepageuser({super.key});

  @override
  State<Homepageuser> createState() => _HomepageuserState();
}

class _HomepageuserState extends State<Homepageuser> {
  final PageController _pageController = PageController(initialPage: 0);
  String? userRole;
  String? userName;
  String? makerId;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final apiService = ApiService();
    final siswaList = await apiService.getProfile();

    if (siswaList.isEmpty) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/login");
      }
      return;
    }

    if (mounted) {
      setState(() {
        userRole = "Siswa";
        userName = siswaList[0]["nama_siswa"] ?? "Siswa";
        makerId = prefs.getString("makerID");

        prefs.setString("username", userName!);
        prefs.setInt("id_user", siswaList[0]["id"]);

        print(siswaList);
      });
    }
  }

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
          children: [
            HomePageContent(
              userName: userName ?? "Guest",
              makerId: makerId ?? "Unknown",
            ),
            ListTran(),
            TestStan()
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
