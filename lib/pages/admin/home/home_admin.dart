import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_kantin/components/navbar_admin.dart';
import 'package:ukk_kantin/pages/admin/home/home_admin_content.dart';
import 'package:ukk_kantin/pages/admin/home/siswa_admin.dart';
import 'package:ukk_kantin/pages/admin/menu_admin/menu_admin_content.dart';
import 'package:ukk_kantin/pages/admin/status/status_admin.dart';
import 'package:ukk_kantin/services/api_services.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  final PageController _pageController = PageController(initialPage: 0);
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
    final prefs = await SharedPreferences.getInstance();
    final apiService = ApiService();
    final stanList = await apiService.getStan();

    if (stanList.isEmpty) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/login");
      }
      return;
    }

    if (mounted) {
      setState(() {
        userRole = "Admin";
        userName = stanList[0]["nama_stan"] ?? "Kantin";
        makerId = prefs.getString("makerID");

        // Simpan id_stan ke SharedPreferences
        prefs.setString("username", userName!);
        prefs.setInt("id_stan", stanList[0]["id"]);
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
        body: userName == null
            ? Center(child: CircularProgressIndicator())
            : PageView(
                controller: _pageController,
                onPageChanged: onPageChanged,
                children: [
                  HomeAdminContent(),
                  StatusAdmin(),
                  MenuAdminContent(),
                  SiswaAdminContent(),
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
