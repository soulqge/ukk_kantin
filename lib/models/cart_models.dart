class CartItem {
  final int idMenu;
  final String namaMakanan;
  final int harga;
  final String jenis;
  final String foto;
  final String deskripsi;
  final int idStan;
  int quantity;

  CartItem({
    required this.idMenu,
    required this.namaMakanan,
    required this.harga,
    required this.jenis,
    required this.foto,
    required this.deskripsi,
    required this.idStan,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      idMenu: json['id_menu'],
      namaMakanan: json['nama_makanan'],
      harga: json['harga'],
      jenis: json['jenis'],
      foto: json['foto'],
      deskripsi: json['deskripsi'],
      idStan: json['id_stan'],
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_menu': idMenu,
      'nama_makanan': namaMakanan,
      'harga': harga,
      'jenis': jenis,
      'foto': foto,
      'deskripsi': deskripsi,
      'id_stan': idStan,
      'quantity': quantity,
    };
  }
}
