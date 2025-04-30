import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/pages/user/pesan/detail_menu.dart';
import 'package:ukk_kantin/services/api_services.dart';

class Stan extends StatefulWidget {
  final String? category;
  final String searchQuery;

  const Stan({
    super.key,
    this.category,
    this.searchQuery = "",
  });

  @override
  State<Stan> createState() => _StanState();
}

class _StanState extends State<Stan> {
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;
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
    List<Map<String, dynamic>> filteredItems = items.where((item) {
      final nama = item["nama_makanan"].toLowerCase();
      final isCategoryMatch =
          widget.category == null || item["jenis"] == widget.category;
      final isSearchMatch = nama.contains(widget.searchQuery);
      return isCategoryMatch && isSearchMatch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                var item = filteredItems[index];

                return InkWell(
                  key: ValueKey(index),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailMenu(dataMenu: item),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 102,
                              height: 102,
                              child:
                                  item["foto"] == null || item["foto"].isEmpty
                                      ? Image.asset("assets/noImage.png",
                                          fit: BoxFit.cover)
                                      : Image.network(
                                          "$baseUrlRil${item["foto"]}",
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                                      "assets/placeholder.png",
                                                      fit: BoxFit.cover),
                                        ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["nama_makanan"],
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text("#${item["jenis"]}",
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Color.fromRGBO(
                                            240, 94, 94, 1))),
                                SizedBox(
                                  height: 18,
                                ),
                                Text(formatCurrency(item["harga"]),
                                    style: GoogleFonts.sen(
                                        fontSize: 17.89,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cart_page');
        },
        backgroundColor: Colors.white,
        child: Icon(SolarIconsBold.cart, color: Colors.black,),
      ),
    );
  }
}
