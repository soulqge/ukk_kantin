import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/pages/user/menuPage.dart'; // Import your menu page

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
        'makanan': 'Nasi Goreng',
        'descMakanan': 'Nasi Goreng Enak',
        'minuman': 'Es Teh',
        'descMinuman': 'Es Teh Enak',
      },
      {
        'name': 'Pak Aril',
        'image': 'assets/placeholder.png',
        'makanan': 'Mie Goreng',
        'descMakanan': 'Mie Goreng Enak',
        'minuman': 'Es Jeruk',
        'descMinuman': 'Es Jeruk Enak',
      },
      {
        'name': 'Bu Cihuy',
        'image': 'assets/placeholder.png',
        'makanan': 'Sate Ayam',
        'descMakanan': 'Sate Ayam Enak',
        'minuman': 'Air Mineral',
        'descMinuman': 'Air Mineral Enak',
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
            color: Colors.white,
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
                      Container(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(240, 94, 94, 1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
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
                          child: Text(
                            "Lihat Menu",
                            style: GoogleFonts.outfit(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
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
