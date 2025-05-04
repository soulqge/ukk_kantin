import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ukk_kantin/components/user_components/checkout_components/button_user.dart';
import 'package:ukk_kantin/components/user_components/checkout_components/dropdown_user.dart';
import 'package:ukk_kantin/models/pesan_models.dart';
import 'package:ukk_kantin/provider/cart_provider.dart';
import 'package:ukk_kantin/services/api_services_user.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

final String baseUrlRil = "https://ukk-p2.smktelkom-mlg.sch.id/";
int quantity = 0;
String? selectedDiskon;

List<Map<String, dynamic>> diskonList = [];

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    fetchDiskon();
  }

  Future<void> fetchDiskon() async {
    final apiService = ApiServicesUser();
    List<dynamic> fetchedDiskonList = await apiService.getDiskon();

    DateTime now = DateTime.now();
    List<Map<String, dynamic>> activeDiskon = fetchedDiskonList
        .where((item) {
          DateTime start = DateTime.parse(item['tanggal_awal']);
          DateTime end = DateTime.parse(item['tanggal_akhir']);
          return now.isAfter(start) && now.isBefore(end);
        })
        .map((item) => {
              'nama': item['nama_diskon'],
              'persentase': item['persentase_diskon'],
            })
        .toList();

    setState(() {
      diskonList = activeDiskon;
    });
  }

  String formatCurrency(int amount) {
    final currencyFormatter = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return currencyFormatter.format(amount);
  }

  int calculateTotalWithDiscount(CartProvider cartProvider) {
    int total = cartProvider.total;
    if (selectedDiskon != null) {
      final diskon = diskonList.firstWhere(
        (element) => element['nama'] == selectedDiskon,
        orElse: () => {'persentase': 0},
      );
      int persentase = diskon['persentase'] ?? 0;
      int diskonAmount = (total * persentase ~/ 100);
      return total - diskonAmount;
    }
    return total;
  }

  Future<void> selesaikanPesanan() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final apiService = ApiServicesUser();

    if (cartProvider.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Keranjang masih kosong.")),
      );
      return;
    }
    final int idStan = cartProvider.items.first.idStan;

    final List<Pesanan> pesananList = cartProvider.items
        .map((item) => Pesanan(idMenu: item.idMenu, qty: item.quantity))
        .toList();

    bool success = await apiService.pesanMakanan(idStan, pesananList);

    if (success) {
      cartProvider.clearCart();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromRGBO(36, 150, 137, 1),
            content: Text(
              "Pesanan berhasil dibuat!",
              style: GoogleFonts.nunitoSans(),
            )),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromRGBO(240, 94, 94, 1),
            content: Text(
              "Gagal membuat pesanan.",
              style: GoogleFonts.nunitoSans(),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Cart",
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Consumer<CartProvider>(
                  builder: (context, cartProvider, _) {
                    if (cartProvider.items.isEmpty) {
                      return Center(child: Text("Keranjang kosong"));
                    }
                    return ListView.builder(
                      itemCount: cartProvider.items.length,
                      itemBuilder: (context, index) {
                        final item = cartProvider.items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width: 112,
                                  height: 112,
                                  child: item.foto.isEmpty
                                      ? Image.asset("assets/placeholder.png",
                                          fit: BoxFit.contain)
                                      : Image.network(
                                          "$baseUrlRil${item.foto}",
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                                      "assets/placeholder.png",
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          item.namaMakanan,
                                          style: GoogleFonts.nunitoSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Expanded(child: Container()),
                                        InkWell(
                                          onTap: () {
                                            cartProvider.removeItem(index);
                                          },
                                          child: Icon(
                                            Icons.remove_circle,
                                            color:
                                                Color.fromRGBO(240, 94, 94, 1),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Text("ID: ${item.idMenu}",
                                        style: GoogleFonts.nunitoSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromRGBO(
                                                240, 94, 94, 1))),
                                    SizedBox(height: 8),
                                    Text("ID: ${item.idStan}",
                                        style: GoogleFonts.sen(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          formatCurrency(item.harga),
                                          style: GoogleFonts.sen(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(child: Container()),
                                        Row(
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  int qty = item.quantity;
                                                  if (qty > 1) {
                                                    cartProvider.decreaseQty(
                                                        index, qty - 1);
                                                  }
                                                },
                                                child: Icon(Icons.remove)),
                                            SizedBox(width: 16),
                                            Text(
                                              item.quantity.toString(),
                                              style: GoogleFonts.nunitoSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 16),
                                            InkWell(
                                                onTap: () {
                                                  int qty = item.quantity;
                                                  cartProvider.increaseQty(
                                                      index, qty + 1);
                                                },
                                                child: Icon(Icons.add)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Text("Diskon",
                  style: GoogleFonts.outfit(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 16),
              DropdownUser(
                hint: "Tidak Ada Diskon",
                items: diskonList,
                onChanged: (value) {
                  setState(() {
                    selectedDiskon = value;
                  });
                },
                value: selectedDiskon,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(formatCurrency(cartProvider.total),
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              if (selectedDiskon != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Diskon ($selectedDiskon)",
                        style: GoogleFonts.outfit(fontSize: 16)),
                    Text(
                      "- ${formatCurrency(cartProvider.total * (diskonList.firstWhere((e) => e['nama'] == selectedDiskon)['persentase']) ~/ 100)}",
                      style:
                          GoogleFonts.outfit(fontSize: 16, color: Colors.green),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Subtotal",
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold, fontSize: 24)),
                  Text(formatCurrency(calculateTotalWithDiscount(cartProvider)),
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold, fontSize: 24)),
                ],
              ),
              SizedBox(height: 16),
              ButtonUser(
                  text: "Selesaikan Pesanan", onPressed: selesaikanPesanan)
            ],
          ),
        ),
      ),
    );
  }
}
