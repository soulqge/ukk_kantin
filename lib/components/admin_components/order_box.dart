import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderBox extends StatelessWidget {
  final int running;
  final int request;

  const OrderBox({super.key, required this.running, required this.request});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 167,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color.fromRGBO(255, 243, 240, 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$running",
                style: GoogleFonts.sen(
                    fontSize: 52.32, fontWeight: FontWeight.bold),
              ),
              Text(
                "Order Baru",
                style:
                    GoogleFonts.sen(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
        Container(
          width: 167,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color.fromRGBO(255, 243, 240, 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$request",
                style: GoogleFonts.sen(
                    fontSize: 52.32, fontWeight: FontWeight.bold),
              ),
              Text(
                "Order Selesai",
                style:
                    GoogleFonts.sen(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }
}
