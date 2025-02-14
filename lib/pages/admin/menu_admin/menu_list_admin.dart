import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuListAdmin extends StatelessWidget {
  final String? category;
  final Random _random = Random();

  MenuListAdmin({this.category});

  final List<Map<String, dynamic>> items = [
    {
      "name": "Nasi Telur",
      "category": "Makanan",
      "price": "Rp6.000",
      "status": "Ready",
      "image": "assets/placeholder.png"
    },
    {
      "name": "Es Campur",
      "category": "Minuman",
      "price": "Rp3.000",
      "status": "Ready",
      "image": "assets/placeholder.png"
    },
    {
      "name": "Nasi Tempe",
      "category": "Makanan",
      "price": "Rp12.000",
      "status": "Sold Out",
      "image": "assets/placeholder.png"
    },
    {
      "name": "Es Teh",
      "category": "Minuman",
      "price": "Rp1.000",
      "status": "Sold Out",
      "image": "assets/placeholder.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredItems = category == null
        ? items
        : items.where((item) => item["category"] == category).toList();

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        var item = filteredItems[index];
        int rating = _random.nextInt(5) + 1; // Generate rating between 1 and 5

        return Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 102,
                  height: 102,
                  child: Image.asset(
                    item["image"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item["name"],
                            style: GoogleFonts.nunitoSans(
                                fontSize: 14, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          item["status"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 4),
                        item["status"] == "Ready"
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : Icon(Icons.cancel, color: Colors.red),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text("#${item["category"]}",
                            style: GoogleFonts.nunitoSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(240, 94, 94, 1))),
                        Spacer(),
                        Text(item["price"],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 18),
                    Row(
                      children: [
                        for (int i = 0; i < rating; i++)
                          Icon(Icons.star, color: Colors.amber, size: 16),
                        for (int i = rating; i < 5; i++)
                          Icon(Icons.star_border, color: Colors.grey, size: 16),
                        Spacer(),
                        InkWell(
                            onTap: () {},
                            child: Text(
                              "Edit",
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 14,
                                  color: Color.fromRGBO(240, 94, 94, 1)),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
