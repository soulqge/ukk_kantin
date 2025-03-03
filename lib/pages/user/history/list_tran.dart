import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:ukk_kantin/components/user_components/history_page_components/button_search.dart';
import 'package:ukk_kantin/components/user_components/history_page_components/hello_act.dart';
import 'package:ukk_kantin/components/user_components/home_page_components/search_bar_user.dart';
import 'package:ukk_kantin/pages/user/history/detail_tran_page.dart';
import 'package:ukk_kantin/services/api_services.dart';

class ListTran extends StatefulWidget {
  const ListTran({super.key});

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
          .then((orders) async {
        for (var order in orders) {
          if (order["detail_trans"] != null) {
            for (var item in order["detail_trans"]) {
              String? namaMenu =
                  await ApiService().getFoodName(item["id_menu"]);

              item["nama_menu"] = namaMenu ?? "Nama tidak ditemukan";
            }
          }
        }
        return orders;
      });
    });
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _statusOptions.map((status) {
              return ListTile(
                title: Text(
                  status,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedStatus = status;
                  });
                  _fetchOrder();
                  Navigator.pop(context); // Tutup modal
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HelloAct(),
          SizedBox(height: 12),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SearchBarUser(
                  width: MediaQuery.sizeOf(context).width * 0.6,
                ),
                ButtonSearch(
                  icon: SolarIconsBold.filter,
                  onTap: () {
                    _showFilterDialog(context);
                  },
                ),
                ButtonSearch(icon: SolarIconsBold.stopwatch)
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _orderList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text("Terjadi kesalahan, coba lagi."));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Tidak ada transaksi."));
                }

                final orderList = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderList.length,
                  itemBuilder: (context, index) {
                    final order = orderList[index];
                    num total = 0;
                    if (order['detail_trans'] != null) {
                      for (var item in order['detail_trans']) {
                        total = total +=
                            (item['qty'] ?? 0) * (item['harga_beli'] ?? 0);
                      }
                    }

                    Color statusColor = (order['status'] == "Dimasak")
                        ? const Color.fromRGBO(240, 94, 94, 1)
                        : Colors.green;

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailTranPage(dataTransaksi: order),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 243, 240, 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          border: Border.all(
                              color: const Color.fromRGBO(240, 94, 94, 1)),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
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
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                    color: Color.fromRGBO(240, 94, 94, 1),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    "Total: ",
                                    style: GoogleFonts.outfit(fontSize: 16),
                                  ),
                                  Text(
                                    formatCurrency.format(total),
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    order['tanggal'],
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
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
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
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
