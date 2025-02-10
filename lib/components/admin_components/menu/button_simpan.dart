import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonSimpan extends StatelessWidget {
  final String hintText;
  final String route;
  final bool isEnabled;

  const ButtonSimpan({
    super.key,
    required this.hintText,
    required this.route,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled
                ? const Color.fromRGBO(240, 94, 94, 1)
                : Colors.grey,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: isEnabled
              ? () {
                  Navigator.pushNamed(context, route);
                }
              : null, // Disable onPressed when button is inactive
          child: Text(
            hintText,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
