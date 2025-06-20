import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionService {
  static const String baseUrl = 'http://192.168.85.187:3000';

  static Future<void> createTransaction(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/transactions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode != 201) {
      print(response.body);
      throw Exception('Gagal menyimpan transaksi');
    }
  }

  static Future<List<dynamic>> getUserTransactions(int userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/transactions'));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List) {
        return decoded;
      } else if (decoded is Map && decoded.containsKey('data')) {
        return decoded['data'] as List<dynamic>;
      } else {
        // If backend returns a single object, wrap it in a list
        return [decoded];
      }
    } else {
      throw Exception('Gagal mengambil data transaksi');
    }
  }
}
