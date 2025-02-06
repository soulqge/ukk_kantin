import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHint extends StatelessWidget {

  final String hint;

  const AdminHint({super.key, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Text(
      hint,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
