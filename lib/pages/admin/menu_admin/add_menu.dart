import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk_kantin/components/admin_components/hello_admin.dart';

import 'package:ukk_kantin/components/admin_components/menu/button_simpan.dart';
import 'package:ukk_kantin/components/admin_components/menu/checkbox_item.dart';
import 'package:ukk_kantin/components/admin_components/menu/item_form.dart';
import 'package:ukk_kantin/components/admin_components/menu/upload_foto.dart';

import 'dart:io';

import 'package:ukk_kantin/services/api_services.dart';

class AddMenu extends StatefulWidget {
  const AddMenu({super.key});

  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  final _formKey = GlobalKey<FormState>();
  String? selectedType;
  bool isButtonEnabled = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? selectedImage;

  void checkFormCompletion() {
    setState(() {
      isButtonEnabled = nameController.text.isNotEmpty &&
          priceController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          selectedType != null;
    });
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(checkFormCompletion);
    priceController.addListener(checkFormCompletion);
    descriptionController.addListener(checkFormCompletion);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void onImageSelected(File image) {
    setState(() {
      selectedImage = image;
      checkFormCompletion();
    });
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) {
      print("Form tidak valid!");
      return;
    }

    bool success = await ApiServiceAdmin().tambahMenu(
      namaMakanan: nameController.text,
      jenis: selectedType!,
      harga: priceController.text,
      deskripsi: descriptionController.text,
      foto: selectedImage,
    );

    if (success) {
      print("Menu berhasil ditambahkan!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromRGBO(36, 150, 137, 1),
            content: Text(
              'Menu berhasil ditambahkan!',
              style: GoogleFonts.nunitoSans(),
            )),
      );
      Navigator.pop(context);
      setState(() {});
    } else {
      print("Gagal menambahkan menu!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromRGBO(240, 94, 94, 1),
            content: Text(
              'Gagal menambahkan menu!',
              style: GoogleFonts.nunitoSans(),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HelloAdmin(
                    kantin: "Tambah Menu Baru",
                  ),
                  SizedBox(height: 16),
                  ItemForm(
                    labelText: "Nama Item",
                    hintText: "Masukkan Nama Item",
                    inputType: TextInputType.text,
                    controller: nameController,
                  ),
                  SizedBox(height: 16),
                  ItemForm(
                    labelText: "Harga dan Tipe",
                    hintText: "Rp,-",
                    inputType: TextInputType.number,
                    controller: priceController,
                  ),
                  Row(
                    children: [
                      CheckboxItem(
                        label: "Makanan",
                        isSelected: selectedType == "makanan",
                        onChanged: (value) {
                          setState(() {
                            selectedType = "makanan";
                            checkFormCompletion();
                          });
                        },
                      ),
                      CheckboxItem(
                        label: "Minuman",
                        isSelected: selectedType == "minuman",
                        onChanged: (value) {
                          setState(() {
                            selectedType = "minuman";
                            checkFormCompletion();
                          });
                        },
                      ),
                    ],
                  ),
                  Text(
                    "Upload Foto Makanan",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16),
                  UploadFoto(
                    onImagePick: (File? image) {
                      if (image != null) {
                        setState(() {
                          selectedImage = image;
                          checkFormCompletion();
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  ItemForm(
                    labelText: "Deskripsi",
                    hintText: "Masukkan Deskripsi Singkat",
                    inputType: TextInputType.text,
                    controller: descriptionController,
                  ),
                  SizedBox(height: 32),
                  ButtonSimpan(
                    hintText: "Simpan",
                    isEnabled: isButtonEnabled,
                    onPressed: submitForm,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
