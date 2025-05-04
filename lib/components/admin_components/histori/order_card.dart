import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ukk_kantin/services/api_services.dart'; // Import API Service

class OrderCard extends StatefulWidget {
  final String id;
  final String total;
  final String tanggal;
  final String waktu;
  final String status;
  final VoidCallback onUpdateStatus; 

  const OrderCard({
    Key? key,
    required this.id,
    required this.total,
    required this.tanggal,
    required this.waktu,
    required this.status,
    required this.onUpdateStatus,
  }) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  String? selectedStatus;

  final List<String> statusList = ["Belum Dikonfirm", "Dimasak", "Diantar", "Sampai"];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.status;
  }

  String formatCurrency(int amount) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return currencyFormatter.format(amount);
  }

  Future<void> _updateStatus(String newStatus) async {
    try {
      await ApiServiceAdmin().updateOrderStatus(widget.id, newStatus.toLowerCase()); // Panggil API
      setState(() {
        selectedStatus = newStatus;
      });
      widget.onUpdateStatus(); // Refresh UI di halaman StatusAdmin
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(240, 94, 94, 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ID Pesanan : ${widget.id}",
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Total : ${formatCurrency(int.tryParse(widget.total) ?? 0)}",
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "${widget.tanggal}  ${widget.waktu}",
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(248, 226, 221, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton<String>(
                  value: selectedStatus,
                  items: statusList.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(
                        status,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _updateStatus(newValue);
                    }
                  },
                  underline: SizedBox(), // Hilangkan garis bawah dropdown
                  dropdownColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
