import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_kantin/services/api_services.dart';

class MenuListAdmin extends StatefulWidget {
  final String? category;

  const MenuListAdmin({super.key, this.category});

  @override
  State<MenuListAdmin> createState() => _MenuListAdminState();
}

class _MenuListAdminState extends State<MenuListAdmin> {
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;
  final Random _random = Random();
  final String baseUrlRil = "https://ukk-p2.smktelkom-mlg.sch.id/";
  int? idStan;

  @override
  void initState() {
    super.initState();
    loadIdStan();
  }

  Future<void> loadIdStan() async {
    final prefs = await SharedPreferences.getInstance();
    int savedIdStan = prefs.getInt("id_stan") ?? 48;
    setState(() {
      idStan = savedIdStan;
    });
    fetchMenus(savedIdStan);
  }

  Future<void> fetchMenus(int stanId) async {
    final apiService = ApiService();
    List<dynamic> makanan = await apiService.getMenuMakanan();
    List<dynamic> minuman = await apiService.getMenuMinuman();
    List<Map<String, dynamic>> response = [...makanan, ...minuman];

    List<Map<String, dynamic>> filteredResponse =
        response.where((item) => item["id_stan"] == stanId).toList();

    if (mounted) {
      setState(() {
        items = filteredResponse;
        isLoading = false;
      });
    }
  }

  Future<void> _deleteMenu(String menuId) async {
    final apiService = ApiService();
    bool success = await apiService.hapusMenu(menuId: menuId);

    if (success) {
      setState(() {
        items.removeWhere((item) => item["id_menu"].toString() == menuId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Menu deleted successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete menu")),
      );
    }
  }

  String formatCurrency(int amount) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return currencyFormatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    if (idStan == null) {
      return const Center(child: CircularProgressIndicator());
    }

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

              return Slidable(
                key: ValueKey(item["id_menu"]),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        // Navigator.pushNamed(
                        //   context,
                        //   "/edit_menu",
                        //   arguments: item,
                        // );
                      },
                      backgroundColor: Color.fromRGBO(147, 147, 147, 1),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Hapus Menu"),
                            content: const Text(
                                "Apakah Anda yakin ingin menghapus menu ini?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  _deleteMenu(item["id_menu"].toString());
                                  Navigator.pop(context);
                                },
                                child: const Text("Hapus"),
                              ),
                            ],
                          ),
                        );
                      },
                      backgroundColor: Color.fromRGBO(240, 94, 94, 1),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Hapus',
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                ),
              );
            },
          );
  }
}
