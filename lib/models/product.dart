class Product {
  final int productId;
  final String namaProduk;
  final String kategori;
  final String deskripsi;
  final double hargaSewa;
  final int stok;
  final String lokasi;
  final String gambar;
  final int tokoId; 

  Product({
    required this.productId,
    required this.namaProduk,
    required this.deskripsi,
    required this.kategori,
    required this.hargaSewa,
    required this.stok,
    required this.lokasi,
    required this.gambar,
    required this.tokoId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      namaProduk: json['nama_produk'],
      deskripsi: json['deskripsi'],
      kategori: json['kategori'],
      hargaSewa: double.tryParse(json['harga_sewa'].toString()) ?? 0.0,
      stok: json['stok'],
      lokasi: json['lokasi'],
      gambar: json['gambar'] ?? '',
      tokoId: json['toko_id'],
    );
  }
}
