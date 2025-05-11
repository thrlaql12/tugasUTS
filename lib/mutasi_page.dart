import 'package:flutter/material.dart';

class MutasiPage extends StatefulWidget {
  @override
  _MutasiPageState createState() => _MutasiPageState();
}

class _MutasiPageState extends State<MutasiPage> {
  String _filter = 'Semua';

  final List<Map<String, dynamic>> _semuaTransaksi = [
    {
      'tanggal': '2025-05-01',
      'jenis': 'Simpanan Wajib',
      'nominal': 100000,
      'keterangan': 'Setoran bulan Mei'
    },
    {
      'tanggal': '2025-05-03',
      'jenis': 'Penarikan',
      'nominal': -50000,
      'keterangan': 'Penarikan simpanan'
    },
    {
      'tanggal': '2025-05-05',
      'jenis': 'Angsuran Pinjaman',
      'nominal': -200000,
      'keterangan': 'Cicilan ke-2'
    },
    {
      'tanggal': '2025-05-07',
      'jenis': 'SHU',
      'nominal': 75000,
      'keterangan': 'Pembagian SHU 2024'
    },
  ];

  List<Map<String, dynamic>> get _filteredTransaksi {
    if (_filter == 'Semua') return _semuaTransaksi;
    return _semuaTransaksi.where((t) => t['jenis'] == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mutasi Transaksi'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _filter,
              items: [
                'Semua',
                'Simpanan Wajib',
                'Penarikan',
                'Angsuran Pinjaman',
                'SHU',
              ]
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _filter = value!;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTransaksi.length,
              itemBuilder: (context, index) {
                final t = _filteredTransaksi[index];
                final isNegative = t['nominal'] < 0;
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(t['jenis']),
                    subtitle: Text("${t['tanggal']} - ${t['keterangan']}"),
                    trailing: Text(
                      "${isNegative ? '-' : '+'}Rp${t['nominal'].abs().toString()}",
                      style: TextStyle(
                        color: isNegative ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
