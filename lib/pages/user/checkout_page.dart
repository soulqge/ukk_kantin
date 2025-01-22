import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

class CheckoutPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const CheckoutPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = order['items'] as List<Map<String, dynamic>>;
    // final totalCount = order['totalCount'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            Text("Checkout"),
            IconButton(
                onPressed: () {}, icon: Icon(SolarIconsBold.mapPointSchool))
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text('Quantity: ${item['count']}'),
          );
        },
      ),
    );
  }
}
