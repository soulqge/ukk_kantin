import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';

class HelloAdminLogout extends StatelessWidget {
  final String kantin;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onLogout;
  final VoidCallback? onEdit;

  const HelloAdminLogout(
      {super.key,
      required this.kantin,
      required this.icon,
      required this.iconColor,
      this.onLogout,
      this.onEdit});

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
              if (onEdit != null) {
                onEdit!();
              }
            },
            icon: Icon(icon, color: iconColor),
          ),
          IconButton(
            onPressed: () {
              if (onLogout != null) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      "Logout",
                      style: GoogleFonts.outfit(),
                    ),
                    content: Text("Apakah Anda yakin ingin logout?",
                        style: GoogleFonts.outfit()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Batal",
                            style: GoogleFonts.outfit(color: Colors.black)),
                      ),
                      TextButton(
                        onPressed: onLogout, // Memanggil fungsi logout
                        child: Text("Logout",
                            style: GoogleFonts.outfit(
                                color: Color.fromRGBO(240, 94, 94, 1))),
                      ),
                    ],
                  ),
                );
              }
            },
            icon: Icon(SolarIconsOutline.logout_2, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
