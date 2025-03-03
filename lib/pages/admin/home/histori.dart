import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ukk_kantin/services/api_services.dart';

class HistoriTransaksiPage extends StatefulWidget {
  const HistoriTransaksiPage({Key? key}) : super(key: key);

  @override
  State<HistoriTransaksiPage> createState() => _HistoriTransaksiPageState();
}

class _HistoriTransaksiPageState extends State<HistoriTransaksiPage> {
  List<Map<String, dynamic>> _historiList = [];

  @override
  void initState() {
    super.initState();
    _fetchHistoriTransaksi();
  }

  Future<void> _fetchHistoriTransaksi() async {
    final orderList = await ApiService().getOrderAdminSelesai();
    setState(() {
      _historiList = orderList
          .where((order) => order["status"].toLowerCase() == "sampai")
          .toList();
    });
  }

  String formatCurrency(int amount) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0);
    return currencyFormatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _historiList.isEmpty
          ? Center(
              child: Text(
              "Belum ada transaksi selesai.",
              style: GoogleFonts.nunitoSans(),
            ))
          : ListView.builder(
              shrinkWrap: true,
              itemCount: _historiList.length,
              itemBuilder: (context, index) {
                final order = _historiList[index];
                final detail = order["detail_trans"].isNotEmpty
                    ? order["detail_trans"][0]
                    : null;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(240, 94, 94, 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID Pesanan: ${order["id"]}",
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Total: ${formatCurrency(int.tryParse(detail["harga_beli"]?.toString() ?? "0") ?? 0)}",
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${order["tanggal"]}  ${order["created_at"].toString().substring(11, 16)}",
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
