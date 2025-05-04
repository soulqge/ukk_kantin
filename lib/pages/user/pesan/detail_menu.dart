import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ukk_kantin/components/user_components/checkout_components/button_user.dart';
import 'package:ukk_kantin/models/cart_models.dart';
import 'package:ukk_kantin/provider/cart_provider.dart';

class DetailMenu extends StatefulWidget {
  final Map<String, dynamic> dataMenu;

  const DetailMenu({super.key, required this.dataMenu});

  @override
  State<DetailMenu> createState() => _DetailMenuState();
}

class _DetailMenuState extends State<DetailMenu> {
  final String baseUrlRil = "https://ukk-p2.smktelkom-mlg.sch.id/";

  int quantity = 0;

  String formatCurrency(int amount) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return currencyFormatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: widget.dataMenu["foto"] == null ||
                            widget.dataMenu["foto"].isEmpty
                        ? Image.asset("assets/placeholder.png",
                            fit: BoxFit.contain)
                        : Image.network(
                            "$baseUrlRil${widget.dataMenu["foto"]}",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset("assets/placeholder.png",
                                    width: 100, height: 100, fit: BoxFit.cover),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.dataMenu["nama_makanan"],
                style: GoogleFonts.nunitoSans(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Kategori: ${widget.dataMenu["jenis"]}",
                style: GoogleFonts.nunitoSans(
                    fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                formatCurrency(widget.dataMenu["harga"]),
                style:
                    GoogleFonts.sen(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                widget.dataMenu["deskripsi"] ?? "Tidak ada deskripsi tersedia.",
                style: GoogleFonts.nunitoSans(fontSize: 14),
              ),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (quantity > 0) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                  ),
                  Text(
                    quantity.toString(),
                    style: GoogleFonts.nunitoSans(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
              ButtonUser(
                text: "Tambah ke Keranjang",
                onPressed: quantity > 0
                    ? () {
                        // Buat CartItem dari Map
                        final cartItem = CartItem.fromJson(widget.dataMenu);

                        // Tambahkan ke provider
                        Provider.of<CartProvider>(context, listen: false)
                            .addToCart(cartItem, quantity);

                        // Pesan
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Item Masuk")),
                        );
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
