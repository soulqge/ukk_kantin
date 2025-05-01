import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/login_components/button_login.dart';
import 'package:ukk_kantin/components/login_components/check.dart';
import 'package:ukk_kantin/components/login_components/form_box_login.dart';
import 'package:ukk_kantin/services/api_services.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();
  File? _image;
  bool isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> registerUser() async {
    setState(() {
      isLoading = true;
    });

    String namaLengkap = namaLengkapController.text.trim();
    String alamat = alamatController.text.trim();
    String password = passwordController.text.trim();
    String telp = noTelpController.text.trim();
    String username = usernameController.text.trim();

    if (namaLengkap.isEmpty ||
        alamat.isEmpty ||
        password.isEmpty ||
        username.isEmpty ||
        telp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromRGBO(240, 94, 94, 1),
          content: Text(
            'Harap isi semua field!',
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
            'Password harus minimal 6 karakter.',
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
      var response = await ApiService().registerStudent(
        namaSiswa: namaLengkap,
        alamat: alamat,
        telp: telp,
        username: username,
        password: password,
        foto: _image,
      );

      if (response['status'] == false) {
        String errorMessage = 'Registrasi gagal.';

        if (response['message'] != null &&
            response['message']['username'] != null &&
            response['message']['username'].isNotEmpty) {
          errorMessage = response['message']['username'][0];
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromRGBO(36, 150, 137, 1),
          content: Text(
            'Registrasi berhasil! Silakan login.',
            style: GoogleFonts.nunitoSans(),
          ),
        ),
      );

      Navigator.pushReplacementNamed(context, '/login_siswa');
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
                Text("Sign Up",
                    style: GoogleFonts.outfit(
                        fontSize: 32, fontWeight: FontWeight.w800)),
                SizedBox(height: 50),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? Icon(Icons.camera_alt,
                              size: 40, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                FormBoxLogin(
                    controller: namaLengkapController,
                    icon: SolarIconsOutline.user,
                    hintText: "Nama Siswa"),
                SizedBox(height: 32),
                FormBoxLogin(
                    controller: alamatController,
                    icon: SolarIconsOutline.map,
                    hintText: "Alamat"),
                SizedBox(height: 32),
                FormBoxLogin(
                    controller: noTelpController,
                    icon: SolarIconsOutline.phone,
                    hintText: "No Telp"),
                SizedBox(height: 32),
                FormBoxLogin(
                    controller: usernameController,
                    icon: SolarIconsOutline.user,
                    hintText: "Username"),
                SizedBox(height: 32),
                FormBoxLogin(
                    controller: passwordController,
                    icon: SolarIconsOutline.lockPassword,
                    hintText: "Password"),
                SizedBox(height: 50),
                CheckText(
                    hintText: "Sudah punya akun?",
                    hintButton: "Login di sini",
                    route: '/login_siswa'),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.06),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ButtonLogin(hintText: "Sign Up", onPressed: registerUser),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
