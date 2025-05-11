import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'settings_screen.dart';
import 'mutasi_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double saldo = 10000000.0; // Rp. 10.000.000

  String formatRupiah(double value) {
    return 'Rp. ${value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  // ================================
  // === FUNGSI FITUR TAMBAHAN ===
  // ================================

  void _launchWhatsApp() async {
    const String nama = "Muhammad Fauqo THuril Aqli";
    final Uri waUrl = Uri.parse(
      "https://api.whatsapp.com/send?phone=6287816447914&text=Halo%20Admin%0ASaya%20*${Uri.encodeComponent(nama)}*%2C%20saya%20ingin%20melakukan%20pinjaman",
    );

    if (await canLaunchUrl(waUrl)) {
      await launchUrl(waUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak dapat membuka WhatsApp")),
      );
    }
  }

  void _showTransferDialog() {
    final rekeningController = TextEditingController();
    final nominalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Transfer Saldo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: rekeningController,
              decoration: const InputDecoration(labelText: "Rekening Tujuan"),
            ),
            TextField(
              controller: nominalController,
              decoration: const InputDecoration(labelText: "Nominal"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Kirim"),
            onPressed: () {
              final nominal = double.tryParse(nominalController.text);
              if (nominal != null && nominal > 0 && nominal <= saldo) {
                setState(() {
                  saldo -= nominal;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Transfer ke ${rekeningController.text} sebesar ${formatRupiah(nominal)} berhasil.",
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Nominal tidak valid atau saldo tidak cukup.")),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog() {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Verifikasi Password"),
        content: TextField(
          controller: passwordController,
          decoration: const InputDecoration(labelText: "Masukkan Password"),
          obscureText: true,
        ),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Lanjut"),
            onPressed: () {
              if (passwordController.text == 'koperasi123') {
                Navigator.pop(context);
                _showQRISDialog();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password salah!")),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showQRISDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("QRIS Pembayaran"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/qrcode.jpg', width: 200, height: 200),
            const SizedBox(height: 10),
            const Text("Scan QRIS untuk melakukan pembayaran"),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Tutup"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showDepositoDialog() {
    final nominalController = TextEditingController();
    int selectedBulan = 6;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text("Buka Deposito"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nominalController,
                decoration: const InputDecoration(labelText: "Nominal Deposito"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              DropdownButton<int>(
                value: selectedBulan,
                items: const [
                  DropdownMenuItem(value: 3, child: Text("3 Bulan")),
                  DropdownMenuItem(value: 6, child: Text("6 Bulan")),
                  DropdownMenuItem(value: 12, child: Text("12 Bulan")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setStateDialog(() {
                      selectedBulan = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Simpan"),
              onPressed: () {
                final nominal = double.tryParse(nominalController.text);
                if (nominal != null && nominal > 0 && nominal <= saldo) {
                  setState(() {
                    saldo -= nominal;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Deposito sebesar ${formatRupiah(nominal)} untuk $selectedBulan bulan berhasil disimpan.",
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Nominal tidak valid atau saldo tidak cukup.")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // ================================
  // === WIDGET BANGUNAN UTAMA ===
  // ================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text("Koperasi Undiksha"),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  _buildMenuItem(Icons.account_balance_wallet, "Cek Saldo", onTap: () {
                    _showSaldoDialog();
                  }),
                  _buildMenuItem(Icons.sync_alt, "Transfer", onTap: _showTransferDialog),
                  _buildMenuItem(Icons.savings, "Deposito", onTap: _showDepositoDialog),
                  _buildMenuItem(Icons.payment, "Pembayaran", onTap: _showPasswordDialog),
                  _buildMenuItem(Icons.attach_money, "Pinjaman", onTap: _launchWhatsApp),
                  _buildMenuItem(Icons.list_alt, "Mutasi", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MutasiPage()),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildHelpCard(),
            const SizedBox(height: 10),
            _buildBottomMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('images/pasfoto.jpg'),
        ),
        title: const Text("Nasabah\nMuhammad Fauqo Thuril Aqli"),
        subtitle: Text("Total Saldo Anda\n${formatRupiah(saldo)}"),
        trailing: Icon(Icons.account_circle, color: Colors.blue[900]),
      ),
    );
  }

  void _showSaldoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Saldo Anda"),
        content: Text(formatRupiah(saldo)),
        actions: [
          TextButton(
            child: const Text("Tutup"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue.shade900, width: 2),
            ),
            child: Icon(icon, color: Colors.blue[900], size: 30),
          ),
          const SizedBox(height: 5),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildHelpCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(Icons.phone, color: Colors.blue[900]),
        title: const Text("Butuh Bantuan?"),
        subtitle: const Text("0878-1644-7914"),
        trailing: Icon(Icons.call, color: Colors.blue[900]),
      ),
    );
  }

  Widget _buildBottomMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBottomIcon(Icons.settings, "Setting", onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        }),
        _buildBottomIcon(Icons.qr_code, "", onTap: () {}),
        _buildBottomIcon(Icons.person, "Profile", onTap: () {}),
      ],
    );
  }

  Widget _buildBottomIcon(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue.shade900, width: 2),
            ),
            child: Icon(icon, color: Colors.blue[900], size: 30),
          ),
          const SizedBox(height: 5),
          if (title.isNotEmpty) Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
