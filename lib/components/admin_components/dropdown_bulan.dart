import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DropdownBulan extends StatelessWidget {
  final String selectedMonth;
  final ValueChanged<String> onChanged;

  const DropdownBulan({
    Key? key,
    required this.selectedMonth,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        labelText: "Pilih Bulan",
        labelStyle: GoogleFonts.outfit(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color.fromRGBO(240, 94, 94, 1),
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      value: selectedMonth,
      items: List.generate(12, (i) {
        final d = DateTime(DateTime.now().year, i + 1);
        final mValue = DateFormat('yyyy-MM').format(d);
        final mDisplay = DateFormat('MMMM yyyy', 'id').format(d);
        return DropdownMenuItem(
          value: mValue,
          child: Text(
            mDisplay,
            style: GoogleFonts.outfit(),
          ),
        );
      }),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
