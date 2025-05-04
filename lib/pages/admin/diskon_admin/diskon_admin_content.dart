import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ukk_kantin/components/admin_components/dropdown_bulan.dart';
import 'package:ukk_kantin/components/admin_components/hello_admin.dart';
import 'package:ukk_kantin/services/api_services.dart';

class RekapOrder extends StatefulWidget {
  @override
  _MonthlyRecapPageState createState() => _MonthlyRecapPageState();
}

class _MonthlyRecapPageState extends State<RekapOrder> {
  List<Map<String, dynamic>> orders = [];
  String _selectedMonth = DateFormat('yyyy-MM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    loadMonthlyRecap();
  }

  Future<void> loadMonthlyRecap() async {
    orders = await ApiServiceAdmin().rekapOrderBulan(_selectedMonth);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HelloAdmin(
              kantin: 'Rekap Pesanan',
            ),
            SizedBox(height: 16),
            DropdownBulan(
              selectedMonth: _selectedMonth,
              onChanged: (month) {
                setState(() => _selectedMonth = month);
                loadMonthlyRecap();
              },
            ),
            SizedBox(height: 16),
            Text(
              "Rekap Pesanan Bulan ${DateFormat('MMMM', 'id').format(DateTime.parse("$_selectedMonth-01"))}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: orders.isEmpty
                  ? Center(child: Text("Tidak ada data untuk bulan ini."))
                  : ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            title: Text(
                              order["nama_siswa"],
                              style: GoogleFonts.outfit(),
                            ),
                            subtitle: Text(
                              "Status: ${order["status"]}\nTanggal: ${order["tanggal"]}",
                              style: GoogleFonts.outfit(),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
