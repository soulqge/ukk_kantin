import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/login_components/button_login.dart';
import 'package:ukk_kantin/components/login_components/check.dart';
import 'package:ukk_kantin/components/login_components/form_box_login.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

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
                  "Sign Up",
                  style: GoogleFonts.outfit(
                      fontSize: 32, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 102),
                FormBoxLogin(
                    icon: SolarIconsOutline.user, hintText: "Full Name"),
                SizedBox(height: 32),
                FormBoxLogin(
                    icon: SolarIconsOutline.letter, hintText: "Email ID"),
                SizedBox(height: 32),
                FormBoxLogin(
                    icon: SolarIconsOutline.lockPassword, hintText: "Password"),
                SizedBox(height: 32),
                FormBoxLogin(
                    icon: SolarIconsOutline.lockPassword, hintText: "Confirm Password"),
                SizedBox(height: 102),
                CheckText(
                  hintText: "Already Have An Account?",
                  hintButton: "Login Here",
                  route: '/login',
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.06),
                ButtonLogin(
                  hintText: "Sign Up",
                  route: '/login',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
