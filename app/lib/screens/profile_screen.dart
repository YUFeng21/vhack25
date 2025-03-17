import 'package:flutter/material.dart';
import 'dart:io';
import '../widgets/base_layout.dart';

class ProfileScreen extends StatelessWidget {
  final String username;
  final String email;
  final String password;
  final File? profileImage;

  const ProfileScreen({super.key, required this.username, required this.email, required this.password, this.profileImage});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      currentIndex: 3,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile-pic.png'), // Fixed round image
            ),
            SizedBox(height: 20),
            Text(
              'Username: $username',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Password: $password',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}