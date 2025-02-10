import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemForm extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType inputType;
  final TextEditingController? controller;

  const ItemForm({
    super.key,
    required this.labelText,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: GoogleFonts.nunitoSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFF5F3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: TextFormField(
              cursorColor: Colors.black,
              controller: controller,
              keyboardType: inputType,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
              style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
