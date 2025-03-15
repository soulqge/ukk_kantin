import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_kantin/services/api_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MenuListAdmin extends StatefulWidget {
  final String? category;

  const MenuListAdmin({super.key, this.category});

  @override
  State<MenuListAdmin> createState() => _MenuListAdminState();
}

class _MenuListAdminState extends State<MenuListAdmin> {
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;
  final String baseUrlRil = "https://ukk-p2.smktelkom-mlg.sch.id/";
  int? idStan;

  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    final apiService = ApiService();
    List<dynamic> response = await apiService.showMenu();

    print("Fetched Menus: ${jsonEncode(response)}");

    List<Map<String, dynamic>> filteredResponse =
        response.map((data) => data as Map<String, dynamic>).toList();

    if (mounted) {
      setState(() {
        items = filteredResponse;
        isLoading = false;
      });
    }
  }

  Future<void> _deleteMenu(String menuId) async {
    print("Attempting to delete menu with ID: $menuId");
    final apiService = ApiService();
    bool success = await apiService.hapusMenu(menuId: menuId);

    if (success) {
      setState(() {
        items.removeWhere((data) => data["id"].toString() == menuId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromRGBO(36, 150, 137, 1),
            content: Text(
              "Menu deleted successfully",
              style: GoogleFonts.nunitoSans(),
            )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromRGBO(240, 94, 94, 1),
            content: Text(
              "Failed to delete menu",
              style: GoogleFonts.nunitoSans(),
            )),
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
    List<Map<String, dynamic>> filteredItems = widget.category == null
        ? items
        : items.where((data) => data["jenis"] == widget.category).toList();

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: Color.fromRGBO(240, 94, 94, 1),
          ))
        : filteredItems.isEmpty
            ? const Center(
                child: Text(
                  "Tidak ada menu tersedia",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  var item = filteredItems[index];

                  return Slidable(
                    key: ValueKey(item["id"]),
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
                                backgroundColor: Colors.white,
                                title: Text(
                                  "Hapus Menu",
                                  style: GoogleFonts.outfit(),
                                ),
                                content: Text(
                                  "Apakah Anda yakin ingin menghapus menu ini?",
                                  style: GoogleFonts.outfit(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      "Batal",
                                      style: GoogleFonts.outfit(
                                          color: Colors.black),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      print("Deleting menu ID: ${item["id"]}");
                                      _deleteMenu(item["id"].toString());
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Hapus",
                                      style: GoogleFonts.outfit(
                                          color:
                                              Color.fromRGBO(240, 94, 94, 1)),
                                    ),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 102,
                              height: 102,
                              child:
                                  item["foto"] == null || item["foto"].isEmpty
                                      ? Image.asset("assets/noImage.png",
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover)
                                      : Image.network(
                                          "$baseUrlRil${item["foto"]}",
                                          fit: BoxFit.cover,
                                          width: 102,
                                          height: 102,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                                      "assets/placeholder.png",
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item["nama_makanan"],
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                  overflow: TextOverflow.ellipsis,
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
