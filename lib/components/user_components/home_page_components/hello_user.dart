import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HelloUser extends StatelessWidget {
  const HelloUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(
            "Hello Faril",
            style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
