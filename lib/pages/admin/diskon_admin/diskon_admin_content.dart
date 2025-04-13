import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/admin_components/hello_admin.dart';

class DiskonAdminContent extends StatefulWidget {
  const DiskonAdminContent({super.key});

  @override
  State<DiskonAdminContent> createState() => _DiskonAdminContentState();
}

class _DiskonAdminContentState extends State<DiskonAdminContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            HelloAdmin(
              kantin: 'Daftar Diskon',
              icon: SolarIconsBold.addCircle,
              iconColor: Colors.red,
              route: '/tambah_diskon',
            ),
          ],
        ),
      ),
    );
  }
}
