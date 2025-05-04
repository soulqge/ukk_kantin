import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/login_components/button_login.dart';
import 'package:ukk_kantin/components/login_components/check.dart';
import 'package:ukk_kantin/components/login_components/form_box_login.dart';
import 'package:ukk_kantin/services/api_services.dart';
import 'package:ukk_kantin/services/api_services_user.dart';

class Loginpageadmin extends StatefulWidget {
  const Loginpageadmin({super.key});

  @override
  _LoginpageadminState createState() => _LoginpageadminState();
}

class _LoginpageadminState extends State<Loginpageadmin> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  late String selectedRole;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    selectedRole = args as String? ?? 'siswa';
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    var response;
    if (selectedRole == 'siswa') {
      response =
          await ApiServicesUser().loginSiswa(username: username, password: password);
    } else {
      response =
          await ApiServiceAdmin().loginStand(username: username, password: password);
    }
    print("Login Response: $response");

    if (response['token'] != null) {
      String token = response['token'];
      String? role = response['role'];
      String? idStan = response['id_stan'];

      await saveLoginData(token, role, idStan);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromRGBO(240, 94, 94, 1),
            content: Text(
              'Login gagal. Periksa kembali kredensial Anda.',
              style: GoogleFonts.nunitoSans(),
            )),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveLoginData(
      String token, String? role, String? makerId) async {
    if (role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromRGBO(240, 94, 94, 1),
            content: Text(
              'Error: Role is null!',
              style: GoogleFonts.nunitoSans(),
            )),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_role', role);

    if (role == 'admin_stan' && makerId != null) {
      await prefs.setString('maker_id', makerId);
    } else if (role == 'admin_stan') {}

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Color.fromRGBO(36, 150, 137, 1),
          content: Text(
            'Login berhasil sebagai $role!',
            style: GoogleFonts.nunitoSans(),
          )),
    );

    if (role == 'siswa') {
      Navigator.popAndPushNamed(context, '/home_user');
    } else if (role == 'admin_stan') {
      Navigator.popAndPushNamed(context, '/home_admin');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromRGBO(240, 94, 94, 1),
            content: Text(
              'Error: Role tidak valid!',
              style: GoogleFonts.nunitoSans(),
            )),
      );
    }
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
                  "Log In",
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 40),
                FormBoxLogin(
                  controller: usernameController,
                  icon: SolarIconsOutline.user,
                  hintText: "Username",
                ),
                SizedBox(height: 16),
                FormBoxLogin(
                  controller: passwordController,
                  icon: SolarIconsOutline.lock,
                  hintText: "Password",
                ),
                SizedBox(height: 40),
                CheckText(
                  hintText: "New User?",
                  hintButton: "Register Here",
                  route: '/signup_admin',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Color.fromRGBO(240, 94, 94, 1),
                      ))
                    : ButtonLogin(
                        hintText: "Log In",
                        onPressed: login,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
