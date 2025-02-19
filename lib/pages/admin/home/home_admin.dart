import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_kantin/components/admin_components/admin_hint.dart';
import 'package:ukk_kantin/components/admin_components/hello_admin_logout.dart';
import 'package:ukk_kantin/components/admin_components/order_box.dart';
import 'package:ukk_kantin/components/admin_components/pemasukan.dart';
import 'package:ukk_kantin/components/navbar_admin.dart';
import 'package:ukk_kantin/pages/admin/home/list_tran_admin.dart';
import 'package:ukk_kantin/pages/admin/home/siswa_admin.dart';
import 'package:ukk_kantin/pages/admin/menu_admin/menu_admin_content.dart';
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
                  const HomeAdminContent(),
                  const MenuAdminContent(),
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

class HomeAdminContent extends StatefulWidget {
  const HomeAdminContent({super.key});

  @override
  State<HomeAdminContent> createState() => _HomeAdminContentState();
}

class _HomeAdminContentState extends State<HomeAdminContent> {
  String kantinName = "Loading...";

  @override
  void initState() {
    super.initState();
    loadAdminData();
  }

  Future<void> loadAdminData() async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username") ?? "Kantin";
    final apiService = ApiService();
    final stanList = await apiService.getStan();

    if (stanList.isNotEmpty) {
      setState(() {
        kantinName = stanList[0]["nama_stan"] ?? username;
      });
    } else {
      setState(() {
        kantinName = username;
      });
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName =
        "Hello ${kantinName[0].toUpperCase()}${kantinName.substring(1)}";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HelloAdminLogout(
                kantin: displayName,
                icon: Icons.person,
                iconColor: Colors.red,
                onLogout: logout,
              ),
              const SizedBox(height: 16),
              OrderBox(running: 6, request: 9),
              const SizedBox(height: 16),
              Pemasukan(penghasilan: 3600000),
              const SizedBox(height: 34),
              const AdminHint(hint: "Daftar Transaksi"),
              const SizedBox(height: 12),
              const ListTranAdmin(),
            ],
          ),
        ),
      ),
    );
  }
}
