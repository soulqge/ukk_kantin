import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';
import 'dart:math' as math;

class DiscountInfo extends StatefulWidget {
  const DiscountInfo({super.key});

  @override
  State<DiscountInfo> createState() => _DiscountInfoState();
}

class _DiscountInfoState extends State<DiscountInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Transform.rotate(
            angle: 90 * math.pi / 180,
            child: Icon(
              SolarIconsBold.tagPrice,
              color: Color.fromRGBO(240, 94, 94, 1),
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Use Discount',
            style: GoogleFonts.nunitoSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(child: Container()),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 10,
              ))
        ],
      ),
    );
  }
}
