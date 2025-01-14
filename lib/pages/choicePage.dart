import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Choicepage extends StatelessWidget {
  const Choicepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text("Siapa Kamu?",
                style: GoogleFonts.outfit(
                    fontSize: 32, fontWeight: FontWeight.w800)),
            SizedBox(height: 64),
            Container(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color.fromRGBO(240, 94, 94, 1),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, route);
                },
                child: Text(
                  "hintText",
                  style: GoogleFonts.outfit(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
