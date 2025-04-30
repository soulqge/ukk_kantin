import 'package:flutter/foundation.dart';
import 'package:ukk_kantin/models/cart_models.dart';
import 'package:ukk_kantin/models/pesan_models.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(CartItem item, int quantity) {
    final index = _items.indexWhere((i) => i.idMenu == item.idMenu);
    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          idMenu: item.idMenu,
          namaMakanan: item.namaMakanan,
          harga: item.harga,
          jenis: item.jenis,
          foto: item.foto,
          deskripsi: item.deskripsi,
          idStan: item.idStan,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void increaseQty(int index, int i) {
    _items[index].quantity++;
    notifyListeners();
  }

  void decreaseQty(int index, int i) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
    }
  }

  int get total {
    return _items.fold(0, (sum, item) => sum + (item.harga * item.quantity));
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  List<Pesanan> toPesananList() {
    return _items
        .map((item) => Pesanan(idMenu: item.idMenu, qty: item.quantity))
        .toList();
  }
}
