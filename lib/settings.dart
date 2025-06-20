import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navbar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Widget untuk item pengaturan
  Widget _buildSettingItem(String title, {VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap ?? () {},
        ),
        const Divider(height: 1),
      ],
    );
  }

  // Fungsi untuk logout
  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // Navigasi ke halaman login
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Foto profil
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.black),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Container pengaturan
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Pengaturan',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 4),

                    // Daftar item pengaturan
                    _buildSettingItem('Ubah Foto Profile'),
                    _buildSettingItem('Ubah Nama'),
                    _buildSettingItem('Ubah Nomor Telepon'),
                    _buildSettingItem('Ubah Password'),
                    _buildSettingItem('Atur No. KTP'),

                    const SizedBox(height: 16),

                    // Tombol Logout
                    _buildSettingItem(
                      'Logout',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Konfirmasi Logout'),
                            content: const Text('Apakah Anda yakin ingin logout?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // tutup dialog
                                  _handleLogout(context);
                                },
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
