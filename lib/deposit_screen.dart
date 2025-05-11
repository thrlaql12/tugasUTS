import 'package:flutter/material.dart';

class DepositScreen extends StatefulWidget {
  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nominalController = TextEditingController();
  String _selectedTenor = '3';
  double _bunga = 0.0;

  // Misal suku bunga tetap 5% per tahun
  double _sukuBunga = 0.05;

  void _hitungBunga() {
    final nominal = double.tryParse(_nominalController.text) ?? 0;
    final tenorBulan = int.parse(_selectedTenor);
    final tenorTahun = tenorBulan / 12.0;
    setState(() {
      _bunga = nominal * _sukuBunga * tenorTahun;
    });
  }

  void _simpanDeposito() {
    if (_formKey.currentState!.validate()) {
      _hitungBunga();
      // Simulasi penyimpanan, di sini kamu bisa kirim ke backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deposito berhasil disimpan')),
      );
    }
  }

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buat Deposito')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Nominal Deposito'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nominal';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedTenor,
                decoration: InputDecoration(labelText: 'Tenor (bulan)'),
                items: ['3', '6', '12'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text('$value Bulan'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTenor = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _simpanDeposito,
                child: Text('Simpan Deposito'),
              ),
              if (_bunga > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Estimasi Bunga: Rp ${_bunga.toStringAsFixed(0)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
