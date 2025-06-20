import 'package:flutter/material.dart';
import 'navbar.dart';
import 'navigation_shop.dart';
import 'detail_product.dart';
import 'cart.dart';
import 'models/product.dart';
import 'services/product_service.dart';

class ShopDetail extends StatefulWidget {
  final Map<String,String> store;

  const ShopDetail({Key? key, required this.store}) : super(key: key);

  @override
  State<ShopDetail> createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  List<Product> cartItems = [];
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    final result = await ProductService.fetchProducts();
    setState(() {
      products = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> store = widget.store;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: SizedBox.shrink(), // Tidak menampilkan konten di appBar
          automaticallyImplyLeading: false, // ini menonaktifkan panah back
          toolbarHeight: 20, // Atur tinggi AppBar sesuai kebutuhan
      ),
      body: Column(
        children: [
          // Detail Toko
          Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 2,
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Gambar toko
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200],
                            ),
                            child: Image.asset(
                              'assets/images/Shop_Icon.png', // Ganti sesuai file kamu
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Nama dan lokasi
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                store['name']!,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text('Lokasi : ${store['location']}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ), 
          // Search Field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          const Divider(),

          // Daftar Produk sebagai GridView 2 kolom
          isLoading
          ? const Center(child: CircularProgressIndicator())
          : Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65, // DARI 0.75 → lebih tinggi item-nya
                ),

                itemBuilder: (context, index) {
                  final product = products[index];
                  final isAdded = cartItems.any((item) => item.productId == product.productId);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailProductPage(product: product),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.grey[100],
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: product.gambar.isNotEmpty
                                  ? Image.asset(
                                      'assets/images/${product.gambar}',
                                      height: 220,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image, size: 100), // fallback jika kosong/null
                            ),

                            const SizedBox(height: 8),
                            Text(product.namaProduk,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text('Kategori : ${product.kategori}',
                                style: const TextStyle(fontSize: 12)),
                            Text('Lokasi    : ${product.lokasi}',
                                style: const TextStyle(fontSize: 12)),
                            Text('Harga     : ${product.hargaSewa}',
                                style: const TextStyle(fontSize: 12)),
                            const Spacer(),
                            ElevatedButton.icon(
                            onPressed: () {
                            setState(() {
                                final currentProduct = products[index];
                                final exists = cartItems.any((item) => item.productId == currentProduct.productId);
                                if (exists) {
                                  cartItems.removeWhere((item) => item.productId == currentProduct.productId);
                                } else {
                                  cartItems.add(currentProduct);
                                }
                              });
                            },
                            icon: Icon(
                              isAdded ? Icons.check : Icons.add,
                              size: 14,
                            ),
                            label: Text(
                              isAdded ? 'Keranjang' : 'Tambah', // Teks berubah sesuai kondisi
                              style: const TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isAdded
                                  ? Colors.green // Warna hijau jika sudah ditambahkan
                                  : Colors.amber, // Warna biru (bukan ungu) jika belum ditambahkan
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 6),
                            ),
                          )

                          ],
                        ),
                      ),

                    ),
                  );
              
                },
              ),
            ),
          ),
        ],
      ),

      // Floating Keranjang
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(selectedProducts: cartItems.toList()),
                ),
              );
            },
            backgroundColor: Colors.amber,
            child: Image.asset(
              'assets/icons/Cart.png',
              width: 24,
              height: 24,
            ),
          ),

          if (cartItems.isNotEmpty)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Center(
                  child: Text(
                    cartItems.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}