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

    print("=== Register Admin Stan ===");
    print("Nama Lengkap: $namaLengkap");
    print("Nama Stan: $namaStan");
    print("Username: $username");
    print("No Telp: $noTelp");
    print("Password: $password");

    try {
      var response = await ApiService().registerStan(
        namaPemilik: namaLengkap,
        namaStan: namaStan,
        username: username,
        telp: noTelp,
        password: password,
      );

      print("Response dari API: $response");

      // Abaikan response, langsung tampilkan pesan sukses dan navigasikan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error saat register: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat registrasi.')),
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
                  route: '/login',
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
