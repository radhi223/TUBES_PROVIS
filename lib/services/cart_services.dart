import 'dart:convert';
import 'package:http/http.dart' as http;

class CartService {
  static const String baseUrl = 'http://192.168.85.187:3000';

  static Future<List<dynamic>> getCart(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/cart/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal mengambil data cart');
    }
  }

  static Future<void> addToCart(Map<String, dynamic> data,
      {String? token}) async {
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.post(
      Uri.parse('$baseUrl/api/cart'),
      headers: headers,
      body: json.encode(data),
    );
    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan item ke cart');
    }
  }

  static Future<void> updateJumlah(int cartId, int jumlah) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cart/$cartId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'jumlah': jumlah}),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal mengupdate jumlah');
    }
  }

  static Future<void> deleteItem(int cartId) async {
    final response = await http.delete(Uri.parse('$baseUrl/cart/$cartId'));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus item');
    }
  }

  static Future<void> clearCart(int userId) async {
    final response = await http.delete(Uri.parse('$baseUrl/cart/user/$userId'));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus seluruh cart');
    }
  }
}
