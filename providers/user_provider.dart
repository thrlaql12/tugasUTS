import 'package:flutter/material.dart';

class User {
  String nama;
  String nomorRekening;

  User({required this.nama, required this.nomorRekening});
}

class UserProvider with ChangeNotifier {
  User _user = User(nama: 'Muhammad Fauqo Thuril Aqli', nomorRekening: '1234567890');

  User get user => _user;

  void updateUser(String nama, String nomorRekening) {
    _user = User(nama: nama, nomorRekening: nomorRekening);
    notifyListeners();
  }
}
