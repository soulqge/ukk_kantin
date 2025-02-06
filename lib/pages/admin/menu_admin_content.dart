import 'package:flutter/material.dart';
import 'package:ukk_kantin/components/admin_components/admin_hint.dart';
import 'package:ukk_kantin/components/admin_components/pemasukan.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/hello_user.dart';
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
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HelloUser(user: 'Pak Aril', icon: Icons.abc, iconColor: Colors.red,),
            SizedBox(height: 48),
            Pemasukan(penghasilan: 3600000),
            SizedBox(height: 34),
            AdminHint(hint: "Daftar Transaksi"),
            SizedBox(height: 12),
            ListTranAdmin()
          ],
        ),
      ),
    );
  }
}
