import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/login_components/button_login.dart';
import 'package:ukk_kantin/components/login_components/form_box_login.dart';
import 'package:ukk_kantin/services/api_services.dart';

class EditMenu extends StatefulWidget {
  final Map<String, dynamic> stanData;

  const EditMenu({super.key, required this.stanData});

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  late TextEditingController namaLengkapController;
  late TextEditingController namaStanController;
  late TextEditingController usernameController;
  late TextEditingController noTelpController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    namaLengkapController =
        TextEditingController(text: widget.stanData['nama_pemilik']);
    namaStanController =
        TextEditingController(text: widget.stanData['nama_stan']);
    usernameController =
        TextEditingController(text: widget.stanData['username']);
    noTelpController = TextEditingController(text: widget.stanData['telp']);
  }

  Future<void> updateStan() async {
    setState(() => isLoading = true);
    print("Mengupdate data stan...");
    print("Nama Pemilik: ${namaLengkapController.text}");
    print("Nama Stan: ${namaStanController.text}");
    print("Username: ${usernameController.text}");
    print("No Telp: ${noTelpController.text}");

    try {
      await ApiService().updateStan(
        id: widget.stanData['id'],
        namaPemilik: namaLengkapController.text.trim(),
        namaStan: namaStanController.text.trim(),
        username: usernameController.text.trim(),
        telp: noTelpController.text.trim(),
      );

      print("Stan berhasil diperbarui!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stan berhasil diperbarui!')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      print("Error saat memperbarui stan: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Terjadi kesalahan saat memperbarui data stan.')),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edit Stan",
                  style: GoogleFonts.outfit(
                      fontSize: 32, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 50),
                FormBoxLogin(
                  controller: namaLengkapController,
                  icon: SolarIconsOutline.user,
                  hintText: "Nama Pemilik",
                ),
                const SizedBox(height: 32),
                FormBoxLogin(
                  controller: namaStanController,
                  icon: SolarIconsOutline.cart,
                  hintText: "Nama Stan",
                ),
                const SizedBox(height: 32),
                FormBoxLogin(
                  controller: usernameController,
                  icon: SolarIconsOutline.user,
                  hintText: "Username",
                ),
                const SizedBox(height: 32),
                FormBoxLogin(
                  controller: noTelpController,
                  icon: SolarIconsOutline.phone,
                  hintText: "No Telp",
                ),
                const SizedBox(height: 50),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ButtonLogin(
                        hintText: "Simpan Perubahan",
                        onPressed: updateStan,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
