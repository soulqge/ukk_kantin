import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHint extends StatelessWidget {

  final String hintHome;
  

  const HomeHint({super.key, required this.hintHome});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          hintHome,
          style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
