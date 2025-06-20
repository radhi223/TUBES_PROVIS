import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://192.168.85.187:3000/api/users';

class AuthService {
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('role', data['user']['role']);
      await prefs.setInt('user_id', data['user']['user_id']);
      await prefs.setString('username', data['user']['username']);
      return true;
    } else {
      print("Login failed: ${response.body}");
      return false;
    }
  }

  static Future<bool> register(String name, String email, String password) async {
  final url = Uri.parse('$baseUrl/register'); // sesuaikan
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': name,
      'email': email,
      'password': password,
      'role': 'penyewa',
    }),
  );
  
  print(response.body);
  print(response.statusCode);

  return response.statusCode == 200;
}


  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
