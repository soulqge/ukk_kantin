import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelloUser extends StatelessWidget {
  final String user;
  final IconData icon;
  final Color iconColor;

  const HelloUser(
      {super.key,
      required this.user,
      required this.icon,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(
            "Hello $user",
            style:
                GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          Expanded(child: Container()),
          Icon(
            icon,
            color: iconColor,
          )
        ],
      ),
    );
  }
}
