import 'package:flutter/material.dart';
import 'package:ukk_kantin/services/api_services.dart';

class OrderPage extends StatelessWidget {
  final ApiService orderService = ApiService();

  void _testOrder() async {
    final orderData = await orderService.pesan();
    if (orderData.isNotEmpty) {
      print("Pesanan berhasil diproses: ${orderData}");
    } else {
      print("Pesanan gagal diproses.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test Pesanan")),
      body: Center(
        child: ElevatedButton(
          onPressed: _testOrder,
          child: Text("Test Pesanan"),
        ),
      ),
    );
  }
}
