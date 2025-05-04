import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/login_components/button_login.dart';
import 'package:ukk_kantin/components/login_components/check.dart';
import 'package:ukk_kantin/components/login_components/form_box_login.dart';
import 'package:ukk_kantin/services/api_services.dart';

class SignupPageAdmin extends StatefulWidget {
  const SignupPageAdmin({super.key});

  @override
  State<SignupPageAdmin> createState() => _SignupPageAdminState();
}

class _SignupPageAdminState extends State<SignupPageAdmin> {
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController namaStanController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> registerAdminStan() async {
    setState(() {
      isLoading = true;
    });

    String namaLengkap = namaLengkapController.text.trim();
    String namaStan = namaStanController.text.trim();
    String username = usernameController.text.trim();
    String noTelp = noTelpController.text.trim();
    String password = passwordController.text.trim();

    // ✅ VALIDASI LOKAL
    if (namaLengkap.isEmpty ||
        namaStan.isEmpty ||
        username.isEmpty ||
        noTelp.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromRGBO(240, 94, 94, 1),
          content: Text(
            'Semua field harus diisi.',
            style: GoogleFonts.nunitoSans(),
          ),
        ),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromRGBO(240, 94, 94, 1),
          content: Text(
            'Password minimal 6 karakter.',
            style: GoogleFonts.nunitoSans(),
          ),
        ),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      var response = await ApiServiceAdmin().registerStan(
        namaPemilik: namaLengkap,
        namaStan: namaStan,
        username: username,
        telp: noTelp,
        password: password,
      );

      print("Response dari API: $response");

      // ✅ VALIDASI DARI SERVER
      if (response['status'] == false) {
        String errorMessage = 'Registrasi gagal.';

        if (response['message'] != null) {
          if (response['message']['username'] != null &&
              response['message']['username'].isNotEmpty) {
            errorMessage = response['message']['username'][0];
          } else if (response['message'] is String) {
            errorMessage = response['message'];
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color.fromRGBO(240, 94, 94, 1),
            content: Text(
              errorMessage,
              style: GoogleFonts.nunitoSans(),
            ),
          ),
        );

        setState(() {
          isLoading = false;
        });
        return;
      }

      // ✅ BERHASIL
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromRGBO(36, 150, 137, 1),
          content: Text(
            'Registrasi berhasil! Silakan login.',
            style: GoogleFonts.nunitoSans(),
          ),
        ),
      );

      Navigator.pushReplacementNamed(context, '/login_admin');
    } catch (e) {
      print("Error saat register: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromRGBO(240, 94, 94, 1),
          content: Text(
            'Terjadi kesalahan saat registrasi.',
            style: GoogleFonts.nunitoSans(),
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

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
                SizedBox(height: 50),
                FormBoxLogin(
                  controller: namaLengkapController,
                  icon: SolarIconsOutline.user,
                  hintText: "Nama Lengkap",
                ),
                SizedBox(height: 32),
                FormBoxLogin(
                  controller: namaStanController,
                  icon: SolarIconsOutline.cart,
                  hintText: "Nama Stan",
                ),
                SizedBox(height: 32),
                FormBoxLogin(
                  controller: usernameController,
                  icon: SolarIconsOutline.user,
                  hintText: "Username",
                ),
                SizedBox(height: 32),
                FormBoxLogin(
                  controller: noTelpController,
                  icon: SolarIconsOutline.phone,
                  hintText: "No Telp",
                ),
                SizedBox(height: 32),
                FormBoxLogin(
                  controller: passwordController,
                  icon: SolarIconsOutline.lockPassword,
                  hintText: "Password",
                ),
                SizedBox(height: 32),
                CheckText(
                  hintText: "Already Have An Account?",
                  hintButton: "Login Here",
                  route: '/login_admin',
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.06),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ButtonLogin(
                        hintText: "Sign Up",
                        onPressed: registerAdminStan,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
