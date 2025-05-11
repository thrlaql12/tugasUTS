import 'package:flutter/material.dart';
import 'login.dart'; // Pastikan kamu punya file login_screen.dart
// import jika ada file lain seperti 'about_screen.dart' bisa ditambah juga

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _logout(BuildContext context) {
    // Navigasi kembali ke halaman login, ganti semua route
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text("Pengaturan"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Ubah Password"),
            onTap: () {
              // Tambahkan navigasi ke halaman ubah password jika ada
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Fitur belum tersedia")),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("Tentang Aplikasi"),
            onTap: () {
              // Tambahkan navigasi ke halaman tentang aplikasi jika ada
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Fitur belum tersedia")),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
