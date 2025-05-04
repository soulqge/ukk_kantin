import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ukk_kantin/services/api_services.dart';

class RekapPemasukanBulan extends StatefulWidget {
  const RekapPemasukanBulan({Key? key}) : super(key: key);

  @override
  State<RekapPemasukanBulan> createState() => _HistoriPemasukanPageState();
}

class _HistoriPemasukanPageState extends State<RekapPemasukanBulan> {
  String _selectedMonth = DateFormat('MM-yyyy').format(DateTime.now());
  Map<String, dynamic> _rekapData = {};
  bool _isLoading = true;

  List<String> _monthOptions = List.generate(12, (index) {
    final date = DateTime(DateTime.now().year, index + 1);
    return DateFormat('MM-yyyy').format(date);
  });

  @override
  void initState() {
    super.initState();
    _fetchRekapData();
  }

  Future<void> _fetchRekapData() async {
    setState(() => _isLoading = true);
    final result = await ApiServiceAdmin().getPemasukan(_selectedMonth);
    setState(() {
      _rekapData = result;
      _isLoading = false;
    });
  }

  String formatCurrency(int amount) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final transaksiList = (_rekapData["data_transaksi"] as List?) ?? [];

    return Column(
      children: [
        // Dropdown untuk memilih bulan
        Padding(
          padding: const EdgeInsets.all(16),
          child: DropdownButtonFormField<String>(
            value: _selectedMonth,
            decoration: InputDecoration(
              labelText: "Pilih Bulan",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: _monthOptions.map((bulan) {
              return DropdownMenuItem(
                value: bulan,
                child: Text(bulan),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedMonth = value);
                _fetchRekapData();
              }
            },
          ),
        ),

        // Loading atau list data
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : transaksiList.isEmpty
                  ? Center(child: Text("Tidak ada data transaksi bulan ini"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: transaksiList.length,
                      itemBuilder: (context, index) {
                        final transaksi = transaksiList[index];
                        final detailList = transaksi["detailTrans"] ?? [];

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
                                "ID Pesanan: ${transaksi["id"]}",
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...detailList.map<Widget>((item) {
                                final harga = int.tryParse(
                                        item["harga_beli"].toString()) ??
                                    0;
                                return Text(
                                  formatCurrency(harga),
                                  style: GoogleFonts.outfit(
                                      color: Colors.white, fontSize: 14),
                                );
                              }).toList(),
                              const SizedBox(height: 8),
                              Text(
                                "${transaksi["tanggal"]} ${transaksi["created_at"].toString().substring(11, 16)}",
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),

        // Total pemasukan
        if (!_isLoading)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Pemasukan:",
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                Text(
                  formatCurrency(_rekapData["total_pemasukan"] ?? 0),
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
      ],
    );
  }
}
