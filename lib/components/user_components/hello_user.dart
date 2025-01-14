import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';

class HelloUser extends StatelessWidget {
  const HelloUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Hello Faril",
          style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        Expanded(child: Container()),
        IconButton(
            onPressed: () {},
            icon: Icon(
              SolarIconsBold.bookmark,
              color: Color.fromRGBO(240, 94, 94, 1),
            ))
      ],
    );
  }
}
