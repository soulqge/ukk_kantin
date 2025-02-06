import 'package:flutter/material.dart';
import 'package:ukk_kantin/components/admin_components/admin_hint.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/hello_user.dart';
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
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HelloUser(
              user: 'Daftar Menu',
              icon: Icons.abc,
              iconColor: Colors.white,
            ),
            SizedBox(height: 48),
            AdminHint(hint: "Daftar Transaksi"),
            SizedBox(height: 12),
            ListTranAdmin()
          ],
        ),
      ),
    );
  }
}
