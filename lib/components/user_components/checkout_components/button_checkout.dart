import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonCheckout extends StatelessWidget {
  final String hint;
  final String route;
  final Color bgColor;
  final Color borderColor;
  final Color fontColor;

  const ButtonCheckout(
      {super.key,
      required this.hint,
      required this.bgColor,
      required this.borderColor,
      required this.route,
      required this.fontColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, route);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            padding: EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(color: borderColor),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Text(
          hint,
          style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: fontColor,
          ),
        ),
      ),
    );
  }
}
