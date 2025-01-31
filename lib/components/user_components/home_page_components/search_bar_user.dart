import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBarUser extends StatelessWidget {

  final double width;

  const SearchBarUser({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Color.fromRGBO(117, 134, 146, 1)
        )
      ),
      child: TextField(
        cursorColor: Color.fromRGBO(117, 134, 146, 1),
        decoration: InputDecoration(
          icon:
              const Icon(Icons.search, color: Color.fromRGBO(117, 134, 146, 1)),
          hintText: "Cari Stan Kamu Disini",
          hintStyle: GoogleFonts.nunitoSans(
              fontSize: 10, color: Color.fromRGBO(117, 134, 146, 1)),
          border: InputBorder.none,
        ),
        onChanged: (query) {
          print("Searching for: $query");
        },
      ),
    );
  }
}
