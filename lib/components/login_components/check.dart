import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckText extends StatelessWidget {
  final String hintText;
  final String hintButton;
  final String route;

  const CheckText(
      {super.key, required this.hintText, required this.hintButton, required this.route});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hintText,
            style: GoogleFonts.nunitoSans(fontSize: 12),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, route);
              },
              child: Text(hintButton,
                  style: GoogleFonts.nunitoSans(
                      fontSize: 12, color: Color.fromRGBO(240, 94, 94, 1))))
        ],
      ),
    );
  }
}
