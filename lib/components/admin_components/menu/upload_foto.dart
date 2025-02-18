import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UploadFoto extends StatefulWidget {
  final Function(File?) onImagePick; // Tambahkan parameter onImagePick

  const UploadFoto({super.key, required this.onImagePick});

  @override
  State<UploadFoto> createState() => _UploadFotoState();
}

class _UploadFotoState extends State<UploadFoto> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });

      widget.onImagePick(_selectedImage); // Kirim ke parent (AddMenu)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: _pickImage,
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(185, 185, 185, 1)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _selectedImage == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload, size: 40),
                    SizedBox(height: 8),
                    Text(
                      "Silahkan Upload Foto Makanan Disini",
                      style: GoogleFonts.nunitoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
        ),
      ),
    );
  }
}
