import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/login_components/button_login.dart';
import 'package:ukk_kantin/components/login_components/choice_options.dart';

class Choicepage extends StatefulWidget {
  const Choicepage({super.key});

  @override
  State<Choicepage> createState() => _ChoicepageState();
}

class _ChoicepageState extends State<Choicepage> {
  String? selectedRole;

  void onRoleSelected(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Siapa Kamu?",
                  style: GoogleFonts.outfit(
                      fontSize: 32, fontWeight: FontWeight.w800)),
              SizedBox(height: 64),
              ChoiceOptions(
                icon: SolarIconsBold.user,
                role: "Students",
                isSelected: selectedRole == "Students",
                onSelected: () => onRoleSelected("Students"),
              ),
              SizedBox(height: 24),
              ChoiceOptions(
                icon: SolarIconsBold.cartLarge,
                role: "Booth Owner",
                isSelected: selectedRole == "Booth Owner",
                onSelected: () => onRoleSelected("Booth Owner"),
              ),
              SizedBox(height: 64),
              selectedRole != null
                  ? Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedRole == "Students"
                                ? "Student"
                                : "Booth Owner",
                            style: GoogleFonts.outfit(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            selectedRole == "Students"
                                ? "Sebagai siswa kamu harus mematuhi peraturan yang sudah ditetapkan oleh sekolah tentang peraturan yang ada di kantin. Melakukan pembayaran dengan jujur dan juga menjaga kebersihan kantin."
                                : "Sebagai pemilik stan kamu harus mematuhi peraturan yang sudah ditetapkan oleh sekolah tentang peraturan yang ada di kantin. Melakukan pengecekan pengeluaran dengan tepat dan juga menjaga kebersihan kantin.",
                            style: GoogleFonts.nunitoSans(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
              Expanded(child: Container()),
              ButtonLogin(hintText: "Next", route: '/login',)
            ],
          ),
        ),
      ),
    );
  }
}
