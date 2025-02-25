import 'package:flutter/material.dart';
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
  final List<String> statusList = ["Order", "Dimasak", "Diantar", "Sampai"];

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
      _orderList = ApiService().getOrderAdmin(selectedStatus);
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
              iconColor: Colors.red,
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.red,
            tabs: statusList.map((status) => Tab(text: status)).toList(),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _orderList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text("Terjadi kesalahan: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Tidak ada pesanan."));
                }

                final orders = snapshot.data!;
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final detail = order["detail_trans"].isNotEmpty
                        ? order["detail_trans"][0]
                        : null;

                    return OrderCard(
                      id: order["id"].toString(),
                      total: detail != null
                          ? detail["harga_beli"].toString()
                          : "0",
                      tanggal: order["tanggal"],
                      waktu: order["created_at"].toString().substring(11, 16),
                      status: statusList[_tabController.index],
                      onUpdateStatus: _fetchOrder,
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
