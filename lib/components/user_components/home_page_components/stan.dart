import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ukk_kantin/services/api_services.dart';

class Stan extends StatefulWidget {
  final String? category;

  const Stan({super.key, this.category});

  @override
  State<Stan> createState() => _StanState();
}

class _StanState extends State<Stan> {
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;
  final Random _random = Random();
  final String baseUrlRil = "https://ukk-p2.smktelkom-mlg.sch.id/";

  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    final apiService = ApiService();
    List<dynamic> makanan = await apiService.getMenuMakanan();
    List<dynamic> minuman = await apiService.getMenuMinuman();
    List<Map<String, dynamic>> response = [...makanan, ...minuman];

    if (mounted) {
      setState(() {
        items = response;
        isLoading = false;
      });
    }
  }

  String formatCurrency(int amount) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return currencyFormatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredItems = widget.category == null
        ? items
        : items.where((item) => item["jenis"] == widget.category).toList();

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              var item = filteredItems[index];
              int rating = _random.nextInt(5) + 1;

              return Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 102,
                        height: 102,
                        child: item["foto"] == null || item["foto"].isEmpty
                            ? Image.asset("assets/noImage.png",
                                width: 100, height: 100, fit: BoxFit.cover)
                            : Image.network(
                                "$baseUrlRil${item["foto"]}",
                                fit: BoxFit.cover,
                                width: 102,
                                height: 102,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset("assets/placeholder.png",
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover),
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item["nama_makanan"],
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("#${item["jenis"]}",
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color.fromRGBO(
                                          240, 94, 94, 1))),
                              const Spacer(),
                              Text(formatCurrency(item["harga"]),
                                  style: GoogleFonts.sen(
                                      fontSize: 17.89,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              for (int i = 0; i < rating; i++)
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                              for (int i = rating; i < 5; i++)
                                const Icon(Icons.star_border,
                                    color: Colors.grey, size: 16),
                              const Spacer(),
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
