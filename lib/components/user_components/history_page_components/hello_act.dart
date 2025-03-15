import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelloAct extends StatelessWidget {
  const HelloAct({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "History",
      style:
          GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }
}
