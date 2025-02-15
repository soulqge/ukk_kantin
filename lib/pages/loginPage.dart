import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/login_components/button_login.dart';
import 'package:ukk_kantin/components/login_components/check.dart';
import 'package:ukk_kantin/components/login_components/form_box_login.dart';
import 'package:ukk_kantin/services/login_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          await ApiService().loginSiswa(username: username, password: password);
    } else {
      response =
          await ApiService().loginStand(username: username, password: password);
    }
    print("Login Response okoko: $response");

    if (response['token'] != null) {
      String token = response['token'];
      String? role = response['role'];
      await saveLoginData(token, role);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Sukses')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Login gagal. Periksa kembali kredensial Anda.')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveLoginData(String token, String? role) async {
    if (role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Role is null!')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_role', role);

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login berhasil sebagai $role!')),
    );

    if (role == 'siswa') {
      Navigator.pushReplacementNamed(context, '/home_user');
    } else if (role == 'admin_stan') {
      Navigator.pushReplacementNamed(context, '/home_admin');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Role tidak valid!')),
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
                  route: selectedRole == "siswa"
                      ? '/signup_siswa'
                      : '/signup_admin',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                isLoading
                    ? Center(child: CircularProgressIndicator())
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
