import 'package:flutter/material.dart';
import 'navbar.dart';
import 'navigation.dart';
import 'detail_product.dart';
import 'models/product.dart';
import 'services/product_service.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late Future<List<Product>> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = ProductService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header image
              Container(
                margin: const EdgeInsets.all(16),
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/Landing1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Search bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Pencarian Produk',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Kategori Produk
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kategori Produk',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.9,
                      children: List.generate(8, (index) {
                        return Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NavigationPage(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/Landing_icon${index + 1}.png',
                                  width: 48,
                                  height: 48,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rekomendasi Produk',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<List<Product>>(
                      future: _productFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Gagal memuat produk: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('Tidak ada produk tersedia.');
                        }

                        final allProducts = snapshot.data!;
                        final products = allProducts.length > 2 ? allProducts.sublist(0, 2) : allProducts;
                        return SizedBox(
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length + 1,
                            itemBuilder: (context, index) {
                              if (index < products.length) {
                                final p = products[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  child: Material(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    elevation: 2,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailProductPage(product: p),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        width: 160,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                              child: p.gambar.isNotEmpty
                                                  ? Image.asset(
                                                      'assets/images/${p.gambar}',
                                                      height: 120,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : const Icon(Icons.image, size: 120),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(p.namaProduk, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                                  const SizedBox(height: 4),
                                                  Text('Lokasi    : ${p.lokasi}', style: const TextStyle(fontSize: 12)),
                                                  Text('Harga     : Rp ${p.hargaSewa.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                // Card "Cek lainnya"
                                return Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  child: Material(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    elevation: 2,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const NavigationPage()),
                                        );
                                      },
                                      child: SizedBox(
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.white,
                                              child: Icon(Icons.arrow_forward, color: Colors.black),
                                            ),
                                            SizedBox(height: 8),
                                            Text('Cek lainnya', style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }

                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
