import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk_kantin/components/admin_components/hello_admin.dart';
import 'package:ukk_kantin/components/admin_components/menu/button_simpan.dart';
import 'package:ukk_kantin/components/admin_components/menu/checkbox_item.dart';
import 'package:ukk_kantin/components/admin_components/menu/item_form.dart';
import 'package:ukk_kantin/components/admin_components/menu/upload_foto.dart';

class AddMenu extends StatefulWidget {
  const AddMenu({super.key});

  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  final _formKey = GlobalKey<FormState>(); // Key to track form state
  String? selectedType; // "Makanan" or "Minuman"
  bool isButtonEnabled = false; // To track if the button is active

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Check if all required fields are filled
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
    // Add listeners to text controllers to check form completion
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
                    icon: Icons.abc,
                    iconColor: Colors.white,
                    route: '/tambah_menu',
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
                        isSelected: selectedType == "Makanan",
                        onChanged: (value) {
                          setState(() {
                            selectedType = "Makanan";
                            checkFormCompletion();
                          });
                        },
                      ),
                      CheckboxItem(
                        label: "Minuman",
                        isSelected: selectedType == "Minuman",
                        onChanged: (value) {
                          setState(() {
                            selectedType = "Minuman";
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
                  UploadFoto(),
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
                    route: '/tambah_menu',
                    isEnabled: isButtonEnabled, // Pass the button state
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
