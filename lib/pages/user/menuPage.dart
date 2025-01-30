import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk_kantin/components/user_components/menu_components/menu_card.dart';
import 'package:ukk_kantin/pages/user/checkout_page.dart';

class Menupage extends StatefulWidget {
  final Map<String, dynamic> stans;

  const Menupage({super.key, required this.stans});

  @override
  State<Menupage> createState() => _MenupageState();
}

class _MenupageState extends State<Menupage> {
  Map<String, int> itemCounts = {};

  @override
  void initState() {
    super.initState();
    for (var item in widget.stans['makanan']) {
      itemCounts[item['name']] = 0;
    }
    for (var item in widget.stans['minuman']) {
      itemCounts[item['name']] = 0;
    }
  }

  List<Map<String, dynamic>> get selectedItems {
    return itemCounts.entries.where((entry) => entry.value > 0).map((entry) {
      var item = widget.stans['makanan'].firstWhere(
        (element) => element['name'] == entry.key,
        orElse: () => <String, Object>{},
      );

      if (item.isEmpty) {
        item = widget.stans['minuman'].firstWhere(
          (element) => element['name'] == entry.key,
          orElse: () =>
              <String, Object>{},
        );
      }

      return {
        'name': entry.key,
        'count': entry.value,
        'price':
            item.isEmpty ? 0 : item['harga'],
      };
    }).toList();
  }

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
                      widget.stans['image']!,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(21),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 94),
                        Text(
                          '${widget.stans['name']}',
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
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildCategorySection(
                        'Aneka Makanan', widget.stans['makanan']),
                    _buildCategorySection(
                        'Aneka Minuman', widget.stans['minuman']),
                  ],
                ),
              ),
              if (itemCounts.values.any((count) => count > 0))
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final order = {
                          'items': selectedItems,
                          'totalCount': itemCounts.values
                              .reduce((a, b) => a + b), // Total quantity
                        };

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                              order: order,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(240, 94, 94, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Beli",
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) {
          return ItemCard(
              image: widget.stans['image'],
              name: item['name'],
              description: item['description'],
              count: itemCounts[item['name']]!,
              onIncrement: () {
                setState(() {
                  itemCounts[item['name']] = itemCounts[item['name']]! + 1;
                });
              },
              onDecrement: () {
                setState(() {
                  if (itemCounts[item['name']]! > 0) {
                    itemCounts[item['name']] = itemCounts[item['name']]! - 1;
                  }
                });
              },
              harga: item['harga']);
        }).toList(),
      ],
    );
  }
}
