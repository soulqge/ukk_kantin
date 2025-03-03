import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelloAdmin extends StatelessWidget {
  final String kantin;
  final IconData? icon;
  final Color? iconColor;
  final String? route;

  const HelloAdmin({
    super.key,
    required this.kantin,
    this.icon,
    this.iconColor,
    this.route,
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
              Navigator.pushNamed(context, route!);
            },
            icon: Icon(icon, color: iconColor),
          ),
        ],
      ),
    );
  }
}
