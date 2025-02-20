import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:solar_icons/solar_icons.dart';

class Pemasukan extends StatefulWidget {
  final int penghasilan;

  const Pemasukan({super.key, required this.penghasilan});

  @override
  _PemasukanState createState() => _PemasukanState();
}

class _PemasukanState extends State<Pemasukan> {
  bool _isHidden = false;

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp.',
      decimalDigits: 0,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color.fromRGBO(255, 243, 240, 1),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 24, 12, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Pemasukan Bulan Ini",
                  style: GoogleFonts.nunitoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isHidden = !_isHidden;
                    });
                  },
                  icon: Icon(
                    _isHidden ? SolarIconsBold.eye : SolarIconsBold.eyeClosed, size: 20,
                  ),
                )
              ],
            ),
            Text(
              _isHidden ? "******" : formatCurrency.format(widget.penghasilan),
              style: GoogleFonts.outfit(
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
