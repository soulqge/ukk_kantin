import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/admin_components/admin_hint.dart';
import 'package:ukk_kantin/components/admin_components/hello_admin.dart';
import 'package:ukk_kantin/pages/admin/home/list_tran_admin.dart';

class MenuAdminContent extends StatefulWidget {
  const MenuAdminContent({super.key});

  @override
  State<MenuAdminContent> createState() => _MenuAdminContentState();
}

class _MenuAdminContentState extends State<MenuAdminContent> {
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
                kantin: 'Daftar Makanan',
                icon: SolarIconsBold.addCircle,
                iconColor: Colors.red,
                route: '/tambah_menu',
              ),
              SizedBox(height: 48),
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
