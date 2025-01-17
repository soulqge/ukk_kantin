import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Menupage extends StatelessWidget {
  final Map<String, dynamic> stans;

  const Menupage({super.key, required this.stans});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      stans['image']!,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(21),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 94),
                        Text(
                          '${stans['name']}',
                          style: GoogleFonts.outfit(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      'Aneka Makanan',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    ...List.generate(
                      stans['makanan'].length,
                      (index) => _buildFoodOrDrinkItem(
                        image: stans['image'],
                        name: stans['makanan'][index]['name'],
                        description: stans['makanan'][index]['description'],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Aneka Minuman',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    ...List.generate(
                      stans['minuman'].length,
                      (index) => _buildFoodOrDrinkItem(
                        image: stans['image'],
                        name: stans['minuman'][index]['name'],
                        description: stans['minuman'][index]['description'],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodOrDrinkItem({
    required String image,
    required String name,
    required String description,
  }) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  image,
                  height: 96,
                  width: 112,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(254, 239, 239, 1),
                        foregroundColor: Color.fromRGBO(240, 94, 94, 1),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color.fromRGBO(240, 94, 94, 1),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "+",
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(color: Color.fromRGBO(117, 134, 146, 1), thickness: 1.3),
        ],
      ),
    );
  }
}
