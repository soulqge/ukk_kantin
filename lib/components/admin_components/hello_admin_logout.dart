import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelloAdminLogout extends StatelessWidget {
  final String kantin;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onLogout; // Tambahkan parameter logout opsional

  const HelloAdminLogout({
    super.key,
    required this.kantin,
    required this.icon,
    required this.iconColor,
    this.onLogout, // Tambahkan parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(
            kantin,
            style:
                GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              if (onLogout != null) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Logout"),
                    content: Text("Apakah Anda yakin ingin logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Batal"),
                      ),
                      TextButton(
                        onPressed: onLogout, // Memanggil fungsi logout
                        child: Text("Logout"),
                      ),
                    ],
                  ),
                );
              }
            },
            icon: Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
