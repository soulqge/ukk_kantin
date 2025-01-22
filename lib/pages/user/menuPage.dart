import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return itemCounts.entries
        .where((entry) => entry.value > 0)
        .map((entry) => {
              'name': entry.key,
              'count': entry.value,
            })
        .toList();
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
              SizedBox(height: 16),
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
                        // Convert the selected items to a Map for CheckoutPage
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
                        backgroundColor: Color.fromRGBO(240, 94, 94, 1),
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
        SizedBox(height: 16),
        ...items.map((item) {
          return _buildFoodOrDrinkItem(
            image: widget.stans['image'],
            name: item['name'],
            description: item['description'],
          );
        }).toList(),
      ],
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
                        color: Color.fromRGBO(117, 134, 146, 1),
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(height: 12),
                    itemCounts[name]! == 0
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                itemCounts[name] = 1;
                              });
                            },
                            child: Container(
                              height: 40,
                              width: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(254, 239, 239, 1),
                                border: Border.all(
                                  color: Color.fromRGBO(240, 94, 94, 1),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '+',
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(240, 94, 94, 1),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(254, 239, 239, 1),
                              border: Border.all(
                                color: Color.fromRGBO(240, 94, 94, 1),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  onPressed: () {
                                    setState(() {
                                      if (itemCounts[name]! > 0) {
                                        itemCounts[name] =
                                            itemCounts[name]! - 1;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: Color.fromRGBO(240, 94, 94, 1),
                                    size: 20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    '${itemCounts[name]}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(240, 94, 94, 1),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  onPressed: () {
                                    setState(() {
                                      itemCounts[name] = itemCounts[name]! + 1;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Color.fromRGBO(240, 94, 94, 1),
                                    size: 20,
                                  ),
                                ),
                              ],
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
