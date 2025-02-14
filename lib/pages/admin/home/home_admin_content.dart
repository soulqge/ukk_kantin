import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String kantinName = "Loading...";

  @override
  void initState() {
    super.initState();
    loadAdminData();
  }

  Future<void> loadAdminData() async {
    String? username = await storage.read(key: "username");
    if (username != null) {
      setState(() {
        kantinName = username;
      });
    } else {
      setState(() {
        kantinName = "Admin";
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
                kantin: kantinName,
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
