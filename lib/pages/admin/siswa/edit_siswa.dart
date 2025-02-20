import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/login_components/button_login.dart';
import 'package:ukk_kantin/components/login_components/form_box_login.dart';
import 'package:ukk_kantin/services/api_services.dart';

class FormEditSiswa extends StatefulWidget {
  final Map<String, dynamic> siswaData;

  const FormEditSiswa({super.key, required this.siswaData});

  @override
  State<FormEditSiswa> createState() => _FormEditSiswaState();
}

class _FormEditSiswaState extends State<FormEditSiswa> {
  late TextEditingController namaLengkapController;
  late TextEditingController alamatController;
  late TextEditingController usernameController;
  late TextEditingController noTelpController;
  File? _image;
  bool isLoading = false;
  final String baseUrlRil = "https://ukk-p2.smktelkom-mlg.sch.id/";

  @override
  void initState() {
    super.initState();
    namaLengkapController =
        TextEditingController(text: widget.siswaData['nama_siswa']);
    alamatController = TextEditingController(text: widget.siswaData['alamat']);
    usernameController =
        TextEditingController(text: widget.siswaData['username']);
    noTelpController = TextEditingController(text: widget.siswaData['telp']);
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      print("Gambar dipilih: ${pickedFile.path}");
    } else {
      print("Tidak ada gambar yang dipilih.");
    }
  }

  Future<void> _submitForm() async {
    setState(() => isLoading = true);
    print("Mengirim data...");
    print("Nama: ${namaLengkapController.text}");
    print("Alamat: ${alamatController.text}");
    print("Telepon: ${noTelpController.text}");
    print("Username: ${usernameController.text}");
    print("Foto: ${_image?.path ?? 'Tidak ada perubahan'}");

    try {
      await ApiService().updateSiswa(
        id: widget.siswaData['id'],
        namaSiswa: namaLengkapController.text.trim(),
        alamat: alamatController.text.trim(),
        telp: noTelpController.text.trim(),
        username: usernameController.text.trim(),
        foto: _image,
      );

      print("Siswa berhasil diperbarui!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Siswa berhasil diperbarui!')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      print("Error saat memperbarui siswa: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Terjadi kesalahan saat memperbarui data siswa.')),
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
                  "Edit Siswa",
                  style: GoogleFonts.outfit(
                      fontSize: 32, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : (widget.siswaData['foto'] != null
                              ? NetworkImage(
                                      "$baseUrlRil${widget.siswaData["foto"]}")
                                  as ImageProvider
                              : null),
                      child: _image == null && widget.siswaData['foto'] == null
                          ? const Icon(Icons.camera_alt,
                              size: 40, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FormBoxLogin(
                    controller: namaLengkapController,
                    icon: SolarIconsOutline.user,
                    hintText: "Nama Siswa"),
                FormBoxLogin(
                    controller: alamatController,
                    icon: SolarIconsOutline.map,
                    hintText: "Alamat"),
                FormBoxLogin(
                    controller: noTelpController,
                    icon: SolarIconsOutline.phone,
                    hintText: "No Telp"),
                FormBoxLogin(
                    controller: usernameController,
                    icon: SolarIconsOutline.user,
                    hintText: "Username"),
                const SizedBox(height: 50),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ButtonLogin(
                        hintText: "Simpan Perubahan", onPressed: _submitForm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
