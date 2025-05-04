import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk_kantin/components/admin_components/hello_admin.dart';
import 'package:ukk_kantin/components/admin_components/histori/order_card.dart';
import 'package:ukk_kantin/services/api_services.dart';

class StatusAdmin extends StatefulWidget {
  const StatusAdmin({super.key});

  @override
  State<StatusAdmin> createState() => _StatusAdminState();
}

class _StatusAdminState extends State<StatusAdmin>
    with SingleTickerProviderStateMixin {
  late Future<List<Map<String, dynamic>>> _orderList;
  late TabController _tabController;
  final List<String> statusList = [
    "Belum Dikonfirm",
    "Dimasak",
    "Diantar",
    "Sampai"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: statusList.length, vsync: this);
    _tabController.addListener(() {
      _fetchOrder();
    });
    _fetchOrder();
  }

  void _fetchOrder() {
    String selectedStatus = statusList[_tabController.index].toLowerCase();
    setState(() {
      _orderList = ApiServiceAdmin().getOrderAdmin(selectedStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: HelloAdmin(
              kantin: 'Status Pesanan',
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Color.fromRGBO(240, 94, 94, 1),
            unselectedLabelColor: Colors.black,
            indicatorColor: Color.fromRGBO(240, 94, 94, 1),
            tabs: statusList.map((status) => Tab(text: status)).toList(),
          ),
          Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _orderList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Color.fromRGBO(240, 94, 94, 1),
                      ));
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text("Terjadi kesalahan: ${snapshot.error}",
                              style: GoogleFonts.outfit()));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text("Tidak ada pesanan.",
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold)));
                    }

                    final orders = snapshot.data!;
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final detailList =
                            order["detail_trans"] as List<dynamic>;

                        final totalHarga = detailList.fold<int>(
                          0,
                          (sum, item) => sum + (item['harga_beli'] as int),
                        );

                        return OrderCard(
                          id: order["id"].toString(),
                          total: totalHarga.toString(),
                          tanggal: order["tanggal"],
                          waktu:
                              order["created_at"].toString().substring(11, 16),
                          status: statusList[_tabController.index],
                          onUpdateStatus: _fetchOrder,
                        );
                      },
                    );
                  })),
        ],
      ),
    );
  }
}
