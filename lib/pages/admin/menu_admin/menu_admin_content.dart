import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/admin_components/hello_admin.dart';
import 'package:ukk_kantin/pages/admin/menu_admin/menu_list_admin.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
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
