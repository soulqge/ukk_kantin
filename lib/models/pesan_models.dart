class Pesanan {
  final int idMenu;
  final int qty;

  Pesanan({required this.idMenu, required this.qty});
  Map<String, dynamic> toMap() {
    return {
      'id_menu': idMenu.toString(),
      'qty': qty.toString(),
    };
  }
}
