import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/login_components/button_login.dart';
import 'package:ukk_kantin/components/login_components/choice_options.dart';

class ChoicePage extends StatefulWidget {
  const ChoicePage({super.key});

  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  String? selectedRole;

  void onRoleSelected(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  void navigateToNextPage() {
    if (selectedRole == "siswa") {
      Navigator.pushNamed(context, '/signup_siswa', arguments: selectedRole);
    } else if (selectedRole == "admin_stan") {
      Navigator.pushNamed(context, '/signup_admin', arguments: selectedRole);
    }
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
                role: "Siswa",
                isSelected: selectedRole == "siswa",
                onSelected: () => onRoleSelected("siswa"),
              ),
              SizedBox(height: 24),
              ChoiceOptions(
                icon: SolarIconsBold.cartLarge,
                role: "Admin Stan",
                isSelected: selectedRole == "admin_stan",
                onSelected: () => onRoleSelected("admin_stan"),
              ),
              SizedBox(height: 64),
              selectedRole != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedRole == "siswa" ? "Siswa" : "Admin Stan",
                          style: GoogleFonts.outfit(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          selectedRole == "siswa"
                              ? "Sebagai siswa kamu harus mematuhi peraturan yang sudah ditetapkan oleh sekolah tentang peraturan yang ada di kantin."
                              : "Sebagai pemilik stan kamu harus mematuhi peraturan yang sudah ditetapkan oleh sekolah.",
                          style: GoogleFonts.nunitoSans(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              Expanded(child: Container()),
              selectedRole != null
                  ? ButtonLogin(
                      hintText: "Next",
                      onPressed: navigateToNextPage,
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
