import 'dart:io';

class User {
  String username;
  String email;
  String password;
  File? profileImage;

  User({
    required this.username,
    required this.email,
    required this.password,
    this.profileImage,
  });
}