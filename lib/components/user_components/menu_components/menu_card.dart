import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemCard extends StatelessWidget {
  final String image;
  final String name;
  final int harga;
  final String description;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ItemCard(
      {super.key,
      required this.image,
      required this.name,
      required this.description,
      required this.count,
      required this.onIncrement,
      required this.onDecrement,
      required this.harga});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 243, 240, 1),
          borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  image,
                  height: 84,
                  width: 84,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 16),
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
                        color: const Color.fromRGBO(117, 134, 146, 1),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 12),
                    count == 0
                        ? Row(
                            children: [
                              Text(
                                "Rp. $harga",
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Expanded(child: Container()),
                              GestureDetector(
                                onTap: onIncrement,
                                child: Container(
                                  height: 40,
                                  width: 60,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(254, 239, 239, 1),
                                    border: Border.all(
                                      color:
                                          const Color.fromRGBO(240, 94, 94, 1),
                                    ),
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                  child: Text(
                                    '+',
                                    style: GoogleFonts.outfit(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromRGBO(240, 94, 94, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                "Rp. $harga",
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Expanded(child: Container()),
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(254, 239, 239, 1),
                                  border: Border.all(
                                    color: const Color.fromRGBO(240, 94, 94, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: onDecrement,
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Color.fromRGBO(240, 94, 94, 1),
                                        size: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        '$count',
                                        style: GoogleFonts.outfit(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromRGBO(
                                              240, 94, 94, 1),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: onIncrement,
                                      icon: const Icon(
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
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
