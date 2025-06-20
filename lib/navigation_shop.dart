import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'navbar.dart';
import 'navigation.dart';
import 'shop_detail.dart';

class NavigationShopPage extends StatefulWidget {
  const NavigationShopPage({super.key});

  @override
  State<NavigationShopPage> createState() => _NavigationShopPageState();
}

class _NavigationShopPageState extends State<NavigationShopPage> {
  List<Map<String, dynamic>> rentalStores = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    fetchStores();
    // print(rentalStores);
  }

  Future<void> fetchStores() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/stores')); 
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      setState(() {
        rentalStores = data.cast<Map<String, dynamic>>();
        isLoading = false;
      });
      // print(response.body);
      // print("JUANCOK");
      // print(rentalStores);
    } else {
      print('Gagal fetch toko');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const SizedBox.shrink(),
        automaticallyImplyLeading: false,
        toolbarHeight: 20,
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari Toko...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          // Tab switcher
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const NavigationPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Center(child: Text('Produk Sewa', style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(width: 2, color: Colors.orange)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const Center(
                    child: Text('Toko Sewa', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),

          const Divider(),

          // Daftar toko
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: rentalStores.length,
                    itemBuilder: (context, index) {
                      final store = rentalStores[index];
                      // print(store);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShopDetail(store: {
                              'nama': store['nama'] ?? 'Toko Tanpa Nama',
                              'lokasi': store['lokasi'] ?? 'Tidak diketahui',
                            })),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Card(
                            elevation: 2,
                            color: Colors.grey[100],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey[200],
                                    ),
                                    child: Image.asset('assets/images/Shop_Icon.png', fit: BoxFit.contain),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(store['nama'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text('Lokasi : ${store['lokasi']}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
