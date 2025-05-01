import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/user_components/history_page_components/button_search.dart';
import 'package:ukk_kantin/components/user_components/history_page_components/hello_act.dart';
import 'package:ukk_kantin/pages/user/history/detail_tran_page.dart';
import 'package:ukk_kantin/services/api_services.dart';

class ListTran extends StatefulWidget {
  const ListTran({
    super.key,
  });

  @override
  State<ListTran> createState() => _ListTranState();
}

class _ListTranState extends State<ListTran> {
  late Future<List<Map<String, dynamic>>> _orderList;
  String _selectedStatus = "belum dikonfirm";
  final List<String> _statusOptions = [
    "Belum Dikonfirm",
    "Dimasak",
    "Diantar",
    "Sampai"
  ];

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  void _fetchOrder() {
    setState(() {
      _orderList = ApiService()
          .getOrderSiswa(_selectedStatus.toLowerCase())
          .then(_enrichOrders);
    });
  }

  Future<List<Map<String, dynamic>>> _enrichOrders(
      List<Map<String, dynamic>> orders) async {
    for (var order in orders) {
      if (order['detail_trans'] is List) {
        for (var item in order['detail_trans']) {
          item['nama_menu'] =
              await ApiService().getFoodName(item['id_menu']) ?? '–';
        }
      }
    }
    return orders;
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: _statusOptions.map((s) {
          return ListTile(
            title: Text(s, style: GoogleFonts.outfit(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              _selectedStatus = s;
              _fetchOrder();
            },
          );
        }).toList(),
      ),
    );
  }

  void _onDateFilterSelected(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color.fromRGBO(240, 94, 94, 1),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color.fromRGBO(240, 94, 94, 1),
              ),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked == null) return;

    final year = picked.year, month = picked.month;
    setState(() {
      _orderList = ApiService()
          .getOrderSiswa(_selectedStatus.toLowerCase())
          .then((orders) async {
        final enriched = await _enrichOrders(orders);
        return enriched.where((order) {
          final d = DateTime.parse(order['tanggal']);
          return d.year == year && d.month == month;
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HelloAct(),
          SizedBox(height: 12),
          Row(
            children: [
              ButtonSearch(
                icon: SolarIconsBold.filter,
                onTap: () => _showFilterDialog(context),
              ),
              SizedBox(width: 12),
              ButtonSearch(
                icon: SolarIconsBold.stopwatch,
                onTap: () => _onDateFilterSelected(context),
              ),
            ],
          ),
          SizedBox(height: 24),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _orderList,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(
                        color: Color.fromRGBO(240, 94, 94, 1)),
                  );
                if (snap.hasError)
                  return Center(child: Text("Error: ${snap.error}"));
                final list = snap.data!;
                if (list.isEmpty)
                  return Center(
                      child: Text("Tidak ada transaksi.",
                          style:
                              GoogleFonts.outfit(fontWeight: FontWeight.bold)));
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final order = list[i];
                    num total = 0;
                    if (order['detail_trans'] is List)
                      for (var item in order['detail_trans'])
                        total += (item['harga_beli'] ?? 0);
                    final statusColor = order['status'] == "Dimasak"
                        ? Color.fromRGBO(240, 94, 94, 1)
                        : Colors.green;
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailTranPage(dataTransaksi: order),
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 243, 240, 1),
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Color.fromRGBO(240, 94, 94, 1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Transaksi #${order['id']}",
                                    style: GoogleFonts.outfit(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios,
                                    size: 15,
                                    color: Color.fromRGBO(240, 94, 94, 1)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Total: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(total)}",
                              style: GoogleFonts.outfit(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(order['tanggal'],
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                                Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: statusColor),
                                  ),
                                  child: Text(
                                    order['status'],
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: statusColor),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
