import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckboxItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool?) onChanged;

  const CheckboxItem({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.black,
          activeColor: Color(0xFFFFF5F3),
          value: isSelected,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.nunito(
            color: Colors.teal,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
