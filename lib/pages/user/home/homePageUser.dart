import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ukk_kantin/components/navbar_user.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/hello_user.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/home_hint.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/search_bar_user.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/stan.dart';
import 'package:ukk_kantin/pages/user/history/history_page_content.dart';

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
    debugSharedPreferences();
    checkAuthentication();
  }

  Future<void> debugSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    print("DEBUG - Token tersimpan: ${prefs.getString("auth_token")}");
    print("DEBUG - MakerID tersimpan: ${prefs.getString("makerID")}");
  }

  /// ✅ Mengecek autentikasi dan mengambil data user
  Future<void> checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");
    String? storedMakerId = prefs.getString("makerID");

    print("Token Home: $token");
    print("Maker ID: $storedMakerId");

    if (token == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/login");
      }
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://ukk-p2.smktelkom-mlg.sch.id/api/get_profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId ?? '23',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Decoded Data: $data");

        if (mounted) {
          setState(() {
            userRole = data['role'];
            userName = data['username'];
            makerId = storedMakerId;
          });
        }
      } else {
        print("Error: ${response.body}");
        await prefs.remove("auth_token");
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/login");
        }
      }
    } catch (e) {
      print("Error saat request: $e");
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
        body: (userName == null || makerId == null)
            ? Center(child: CircularProgressIndicator())
            : PageView(
                controller: _pageController,
                onPageChanged: onPageChanged,
                children: [
                  HomePageContent(
                    userName: userName ?? "Guest", // 🔹 Fallback jika `null`
                    makerId: makerId ?? "Unknown",
                  ),
                  HistoryPageContent(),
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

class HomePageContent extends StatelessWidget {
  final String userName;
  final String makerId;

  const HomePageContent({
    super.key,
    required this.userName,
    required this.makerId,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HelloUser(
              user: userName, // 🔹 Pastikan user tidak null
              icon: Icons.person,
              iconColor: Colors.white,
            ),
            SizedBox(height: 48),
            SearchBarUser(width: double.infinity),
            SizedBox(height: 28),
            HomeHint(hintHome: "Untuk Kamu"),
            SizedBox(height: 4),
            Stan(),
          ],
        ),
      ),
    );
  }
}
