import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/user_components/button_login.dart';
import 'package:ukk_kantin/components/user_components/check.dart';
import 'package:ukk_kantin/components/user_components/form_box_login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Log In",
                  style: GoogleFonts.outfit(
                      fontSize: 32, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 156),
                FormBoxLogin(
                    icon: SolarIconsOutline.letter, hintText: "Email ID"),
                SizedBox(height: 32),
                FormBoxLogin(icon: SolarIconsOutline.lock, hintText: "Password"),
                SizedBox(height: 156),
                CheckText(hintText: "New User?", hintButton: "Register Here", route: '/signup',),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.16),
                ButtonLogin(hintText: "Log In",)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
