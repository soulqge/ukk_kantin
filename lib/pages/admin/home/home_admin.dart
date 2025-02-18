import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/admin_components/admin_hint.dart';
import 'package:ukk_kantin/components/admin_components/hello_admin.dart';
import 'package:ukk_kantin/components/admin_components/order_box.dart';
import 'package:ukk_kantin/components/admin_components/pemasukan.dart';
import 'package:ukk_kantin/components/navbar_admin.dart';
import 'package:ukk_kantin/pages/admin/home/list_tran_admin.dart';
import 'package:ukk_kantin/pages/admin/menu_admin/menu_admin_content.dart';
import 'package:ukk_kantin/pages/admin/menu_admin/menu_list_admin.dart';
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

    final userData = await apiService.fetchUserData();
    if (userData == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/login");
      }
      return;
    }

    if (mounted) {
      setState(() {
        userRole = userData['role'] ?? "Admin";
        userName = userData['data']?['nama_pemilik'] ?? "Kantin";
        makerId = prefs.getString("makerID");

        prefs.setString("username", userName!);
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
                  HomeAdminContent(userName: userName ?? "Admin"),
                  MenuAdminContent(),
                  HomeAdminContent(userName: userName ?? "Admin"),
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
  final String userName;

  const HomeAdminContent({super.key, required this.userName});

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
    String? username = prefs.getString("username");

    if (mounted) {
      setState(() {
        kantinName = username ?? widget.userName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HelloAdmin(
                kantin:
                    "Hello ${kantinName[0].toUpperCase()}${kantinName.substring(1)}",
                icon: Icons.person,
                iconColor: Colors.red,
                route: '/home_admin',
              ),
              SizedBox(height: 16),
              OrderBox(running: 6, request: 9),
              SizedBox(height: 16),
              Pemasukan(penghasilan: 3600000),
              SizedBox(height: 34),
              AdminHint(hint: "Daftar Transaksi"),
              SizedBox(height: 12),
              ListTranAdmin()
            ],
          ),
        ),
      ),
    );
  }
}

class MenuAdminContent extends StatefulWidget {
  const MenuAdminContent({super.key});

  @override
  State<MenuAdminContent> createState() => _MenuAdminContentState();
}

class _MenuAdminContentState extends State<MenuAdminContent> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: HelloAdmin(
                kantin: 'Daftar Makanan',
                icon: SolarIconsBold.addCircle,
                iconColor: Colors.red,
                route: '/tambah_menu',
              ),
            ),
            TabBar(
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.red,
              tabs: [
                Tab(text: "Semua"),
                Tab(text: "Makanan"),
                Tab(text: "Minuman"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  MenuListAdmin(),
                  MenuListAdmin(category: "makanan"),
                  MenuListAdmin(category: "minuman"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
