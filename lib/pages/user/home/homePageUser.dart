import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ukk_kantin/components/navbar_user.dart';
import 'package:ukk_kantin/pages/user/history/history_page_content.dart';
import 'package:ukk_kantin/pages/user/home/home_page_content.dart';

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
    String? token = prefs.getString("auth_token");
    String? storedMakerId = prefs.getString("makerID");

    print("Token: $token"); // Debugging token
    print("Maker ID: $storedMakerId"); // Debugging maker ID

    if (token == null) {
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://ukk-p2.smktelkom-mlg.sch.id/api/get_siswa'),
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
        setState(() {
          userRole = data['role'];
          userName = data['username'];
          makerId = storedMakerId;
        });
      } else {
        print("Error: ${response.body}");
        await prefs.remove("auth_token");
        Navigator.pushReplacementNamed(context, "/login");
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
                    userName: userName!,
                    makerId: makerId!,
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
