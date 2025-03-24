import 'package:flutter/material.dart';
import '../models/user.dart';
import 'dart:io';

class UserProvider with ChangeNotifier {
  User _user = User(username: '', email: '', password: '');

  User get user => _user;

  void updateUser(String username, String email, String password, File? profileImage) {
    _user = User(username: username, email: email, password: password, profileImage: profileImage);
    notifyListeners();
  }

  void clearUser() {
    _user = User(username: '', email: '', password: '');
    notifyListeners();
  }
}