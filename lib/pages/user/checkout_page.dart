import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk_kantin/components/user_components/checkout_components/button_checkout.dart';
import 'package:ukk_kantin/components/user_components/checkout_components/discount_info.dart';
import 'package:ukk_kantin/components/user_components/checkout_components/price_info.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> order;

  const CheckoutPage({Key? key, required this.order}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    final items = widget.order['items'] as List<Map<String, dynamic>>;

    double totalPrice = items.fold(0, (sum, item) {
      return sum + (item['count'] * item['price']);
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: Text(
            "Checkout",
            style: GoogleFonts.nunitoSans(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${item['count']}x',
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item['name'],
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                'Rp ${item['price']}',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Divider()
                        ],
                      ),
                    );
                  },
                ),
              ),
              Divider(),
              DiscountInfo(),
              SizedBox(height: 13),
              PriceInfo(price: 'Rp.$totalPrice'),
              SizedBox(height: 24),
              Column(
                children: [
                  ButtonCheckout(
                    hint: "Selesaikan Pesanan",
                    bgColor: Color.fromRGBO(240, 94, 94, 1),
                    borderColor: Color.fromRGBO(240, 94, 94, 1),
                    route: '/home_user',
                    fontColor: Colors.white,
                  ),
                  SizedBox(height: 12),
                  ButtonCheckout(
                    hint: "Print Checkout",
                    bgColor: Colors.white,
                    borderColor: Color.fromRGBO(240, 94, 94, 1),
                    route: '/home_user',
                    fontColor: Color.fromRGBO(240, 94, 94, 1),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
