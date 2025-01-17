import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/user_components/menu_components/menu_button.dart';
import 'package:ukk_kantin/pages/user/menuPage.dart';

class Stan extends StatefulWidget {
  const Stan({super.key});

  @override
  State<Stan> createState() => _StanState();
}

class _StanState extends State<Stan> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> stans = [
      {
        'name': 'Pak Yoyok',
        'image': 'assets/placeholder.png',
        'makanan': [
          {'name': 'Nasi Goreng', 'description': 'Nasi Goreng Enak'},
          {'name': 'Sate Ayam', 'description': 'Sate Ayam Enak'},
        ],
        'minuman': [
          {'name': 'Es Teh', 'description': 'Es Teh Enak'},
          {'name': 'Air Mineral', 'description': 'Air Mineral Segar'},
        ],
      },
      {
        'name': 'Pak Aril',
        'image': 'assets/placeholder.png',
        'makanan': [
          {'name': 'Mie Goreng', 'description': 'Mie Goreng Enak'},
          {'name': 'Nasi Uduk', 'description': 'Nasi Uduk Lezat'},
        ],
        'minuman': [
          {'name': 'Es Jeruk', 'description': 'Es Jeruk Segar'},
          {'name': 'Kopi Hitam', 'description': 'Kopi Hitam Mantap'},
        ],
      },
      {
        'name': 'Bu Cihuy',
        'image': 'assets/placeholder.png',
        'makanan': [
          {'name': 'Mie Ayam', 'description': 'Mie Ayam Enak'},
          {'name': 'Nasi Katsu', 'description': 'Nasi Katsu Lezat'},
        ],
        'minuman': [
          {'name': 'Es Milo', 'description': 'Es Jeruk Segar'},
          {'name': 'Kopi', 'description': 'Kopi Mantap'},
        ],
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: stans.length,
      itemBuilder: (context, index) {
        final stan = stans[index];
        return Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 243, 240, 1),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Image.asset(
                  stan['image']!,
                  width: 146,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              stan['name']!,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.06,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // To be implemented
                            },
                            icon: Icon(
                              SolarIconsBold.bookmark,
                              color: Color.fromRGBO(240, 94, 94, 1),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      MenuButton(
                        label: "Lihat Menu",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Menupage(
                                stans: stan,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
