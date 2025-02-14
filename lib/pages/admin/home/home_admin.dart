import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ukk_kantin/components/navbar_admin.dart';
import 'package:ukk_kantin/pages/admin/home/home_admin_content.dart';
import 'package:ukk_kantin/pages/admin/menu_admin/menu_admin_content.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  final PageController _pageController = PageController(initialPage: 0);
  final FlutterSecureStorage storage = FlutterSecureStorage();

  int _currentPage = 0;
  String? userRole;
  String? userName;
  String? makerId;

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    try {
      String? token = await storage.read(key: "auth_token");
      String? storedMakerId = await storage.read(key: "makerID");

      if (token == null) {
        if (mounted) Navigator.pushReplacementNamed(context, "/login");
        return;
      }

      final response = await http.get(
        Uri.parse('https://ukk-p2.smktelkom-mlg.sch.id/api/get_stan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'makerID': storedMakerId ?? '23',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            userRole = data['role'];
            userName = data['username'];
            makerId = storedMakerId;
          });
        }
      } else {
        await storage.delete(key: "auth_token");
        if (mounted) Navigator.pushReplacementNamed(context, "/login");
      }
    } catch (e) {
      print("Error during authentication check: $e");
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
        body: userName == null
            ? Center(child: CircularProgressIndicator())
            : PageView(
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
