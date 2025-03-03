import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailTranPage extends StatefulWidget {
  final Map<String, dynamic> dataTransaksi;

  const DetailTranPage({super.key, required this.dataTransaksi});

  @override
  State<DetailTranPage> createState() => _DetailTransactionState();
}

class _DetailTransactionState extends State<DetailTranPage> {
  final NumberFormat numberFormat = NumberFormat("#,###", "id_ID");

  num jumlah = 0;
  num totalHarga = 0;
  num totalHargaAkhir = 0;
  List<String> itemName = [];

  @override
  void initState() {
    super.initState();
    _initializeTransactionDetails();
  }

  Future<void> _initializeTransactionDetails() async {
    _calculateTotalItemAndPrice();
    setState(() {});
  }

  void _calculateTotalItemAndPrice() {
    jumlah = 0;
    totalHarga = 0;

    for (var item in widget.dataTransaksi["detail_trans"]) {
      jumlah += item["qty"];
      totalHarga += (item['qty'] ?? 0) * (item['harga_beli'] ?? 0);
    }
    totalHargaAkhir = totalHarga;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Color.fromRGBO(240, 94, 94, 1),
                        )),
                    Text("Detail Order",
                        style: GoogleFonts.outfit(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                  ],
                )),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(26),
                children: [
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTransactionHeader(),
                          const SizedBox(height: 18),
                          const Divider(
                            height: 0,
                            color: Color.fromRGBO(214, 214, 214, 1),
                          ),
                          const SizedBox(height: 18),
                          _buildItemList(),
                          const SizedBox(height: 10),
                          const Divider(
                            height: 0,
                            color: Color.fromRGBO(214, 214, 214, 1),
                          ),
                          const SizedBox(height: 18),
                          _buildPaymentDetails(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHeader() {
    DateTime date = DateTime.parse(widget.dataTransaksi["tanggal"]);
    String formattedDate =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$formattedDate", style: GoogleFonts.outfit()),
        Text(widget.dataTransaksi["status"].toString().capitalize(),
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildItemList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(widget.dataTransaksi["detail_trans"].length, (i) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border:
                          Border.all(color: Color.fromRGBO(240, 94, 94, 1))),
                  child: Text(
                      "${widget.dataTransaksi["detail_trans"][i]["qty"]}x",
                      style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(240, 94, 94, 1))),
                ),
                SizedBox(
                  width: 8,
                ),
                Text("${widget.dataTransaksi["detail_trans"][i]["nama_menu"]}",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                Spacer(),
                Text(
                    "Rp.${numberFormat.format(widget.dataTransaksi["detail_trans"][i]["harga_beli"])}",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
            const SizedBox(height: 8),
          ],
        );
      }),
    );
  }

  Widget _buildPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Subtotal", style: GoogleFonts.nunitoSans()),
            Text("Rp.${numberFormat.format(totalHarga)}",
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
        const SizedBox(height: 18),
        const Divider(
          height: 0,
          color: Color.fromRGBO(214, 214, 214, 1),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', softWrap: true, style: GoogleFonts.nunitoSans()),
            Text('Rp.${numberFormat.format(totalHargaAkhir)}',
                softWrap: true,
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
