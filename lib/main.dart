import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'daftar_menu.dart';
import 'landing.dart';
import 'settings.dart'; // jika kamu punya halaman Settings

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  runApp(MyApp(startPage: token != null ? const LandingPage() : const LoginPage()));
}

class MyApp extends StatelessWidget {
  final Widget startPage;
  const MyApp({super.key, required this.startPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campago',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: startPage,

      // ✅ Tambahkan route-named di sini
      routes: {
        '/login': (context) => const LoginPage(),
        '/landing': (context) => const LandingPage(),
        '/daftar_menu': (context) => DaftarMenu(),
        '/settings': (context) => const SettingsPage(), // opsional
      },
    );
  }
}
