import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionService {
  static const String baseUrl = 'http://localhost:3000'; // Ganti jika backend online

  static Future<List<dynamic>> getAllTransactions() async {
    final response = await http.get(Uri.parse('$baseUrl/transactions'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal mengambil data transaksi');
    }
  }

  static Future<Map<String, dynamic>> getTransactionById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/transactions/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Transaksi tidak ditemukan');
    }
  }

  static Future<void> createTransaction(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode != 201) {
      throw Exception('Gagal membuat transaksi');
    }
  }

  static Future<void> updateStatus(int id, String statusItem) async {
    final response = await http.put(
      Uri.parse('$baseUrl/transactions/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status_item': statusItem}),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal update status transaksi');
    }
  }

  static Future<void> deleteTransaction(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/transactions/$id'));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus transaksi');
    }
  }
}
