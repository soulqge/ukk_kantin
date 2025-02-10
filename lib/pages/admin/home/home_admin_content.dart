import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk_kantin/components/admin_components/admin_hint.dart';
import 'package:ukk_kantin/components/admin_components/hello_admin.dart';
import 'package:ukk_kantin/components/admin_components/order_box.dart';
import 'package:ukk_kantin/components/admin_components/pemasukan.dart';
import 'package:ukk_kantin/pages/admin/home/list_tran_admin.dart';

class HomeAdminContent extends StatefulWidget {
  const HomeAdminContent({super.key});

  @override
  State<HomeAdminContent> createState() => _HomeAdminContentState();
}

class _HomeAdminContentState extends State<HomeAdminContent> {
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
                kantin: 'Pak Aril',
                icon: Icons.abc,
                iconColor: Colors.red,
                route: '/home_admin',
              ),
              SizedBox(height: 16),
              OrderBox(running: 06, request: 09),
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
