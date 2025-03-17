import 'package:flutter/material.dart';
import 'dart:io';
import '../widgets/base_layout.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Function(String, String, String, String, File?) updateUserDetails;

  SignInScreen({super.key, required this.updateUserDetails});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      currentIndex: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;
                updateUserDetails(username, '', password, password, null);
                Navigator.pushNamed(context, '/profile');
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}