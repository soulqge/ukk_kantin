import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormBoxLogin extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController? controller;

  const FormBoxLogin(
      {super.key, required this.icon, required this.hintText, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(117, 134, 146, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromRGBO(117, 134, 146, 1), width: 2),
          ),
          prefixIcon: Icon(
            icon,
            color: Color.fromRGBO(240, 94, 94, 1),
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.nunitoSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(117, 134, 146, 1)),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16)),
    );
  }
}
