import 'package:flutter/material.dart';
import 'success_payment.dart';
import 'models/product.dart';

class PaymentPage extends StatefulWidget {
  final Object? product;

  const PaymentPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool useShipping = false;
  String? selectedPayment;
  String? selectedCourier;
  final TextEditingController addressController = TextEditingController(
    text: "Jl. Dr. Setiabudi No.229, Isola,\nKec. Sukasari, Kota Bandung,\nJawa Barat 40154",
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> productCards = [];
    int totalQuantity = 0;
    int totalPrice = 0;

    // Ambil data dan bangun UI produk
    if (widget.product is Map<String, dynamic>) {
      final productMap = widget.product as Map<String, dynamic>;
      final productObj = productMap["product"] as Product;
      final quantity = productMap["quantity"] as int;
      productCards.add(buildProductCard(productObj, quantity));
      totalPrice += productObj.hargaSewa.toInt() * quantity;
      totalQuantity += quantity;
    } else if (widget.product is List<Map<String, dynamic>>) {
      final products = widget.product as List<Map<String, dynamic>>;
      for (var product in products) {
        final productObj = product["product"] as Product;
        final quantity = product["quantity"] as int;
        productCards.add(buildProductCard(productObj, quantity));
        totalPrice += productObj.hargaSewa.toInt() * quantity;
        totalQuantity += quantity;
      }
    }

    const int appFee = 2000;
    int shippingFee = useShipping ? 10000 : 0;
    int total = totalPrice + appFee + shippingFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            ...productCards,
            const SizedBox(height: 16),

            // Metode Pembayaran
            Card(
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  buildPaymentOption("QRIS", "assets/images/qris.png"),
                  buildPaymentOption("GOPAY", "assets/images/gopay.png"),
                  buildPaymentOption("DANA", "assets/images/dana.png"),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Detail Tagihan
            Card(
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Detail Tagihan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    buildDetailRow("Biaya Produk ($totalQuantity)", totalPrice),
                    buildDetailRow("Biaya Pengiriman", shippingFee),
                    buildDetailRow("Biaya Jasa Aplikasi", appFee),
                    const Divider(),
                    buildDetailRow("Total Tagihan", total, isBold: true),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tombol Konfirmasi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Konfirmasi pembayaran"),
                onPressed: () {
                  if (selectedPayment == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Pilih metode pembayaran terlebih dahulu.")),
                    );
                    return;
                  }

                  if (useShipping && selectedCourier == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Pilih jasa pengiriman terlebih dahulu.")),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SuccessPaymentPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductCard(Product product, int jumlah) {
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/images/' + product.gambar,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.namaProduk, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  buildProductInfo("Kategori", product.kategori),
                  buildProductInfo("Lokasi", product.lokasi),
                  buildProductInfo("Harga", "Rp. ${product.hargaSewa}"),
                  buildProductInfo("Jumlah Disewa", jumlah.toString()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildProductInfo(String label, String? value) {
    String textValue = value == null || value.isEmpty ? "-" : value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: textValue,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentOption(String method, String assetPath) {
    return ListTile(
      leading: Image.asset(assetPath, width: 30),
      title: Text(method),
      trailing: Radio<String>(
        value: method,
        groupValue: selectedPayment,
        onChanged: (val) {
          if (val != null) {
            setState(() {
              selectedPayment = val;
            });
          }
        },
      ),
    );
  }

  Widget buildCourierOption(String name, String assetPath) {
    return ListTile(
      leading: Image.asset(assetPath, width: 40),
      title: Text(name),
      trailing: Radio<String>(
        value: name,
        groupValue: selectedCourier,
        onChanged: (val) {
          if (val != null) {
            setState(() {
              selectedCourier = val;
            });
          }
        },
      ),
    );
  }

  Widget buildDetailRow(String label, int amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null),
          Text("Rp. $amount", style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}
