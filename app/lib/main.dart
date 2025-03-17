import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/profile_screen.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _username = '';
  String _email = '';
  String _password = '';
  File? _profileImage;

  void _updateUserDetails(String username, String email, String password, String confirmPassword, File? profileImage) {
    setState(() {
      _username = username;
      _email = email;
      _password = password;
      _profileImage = profileImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agriculture App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/sign-in': (context) => SignInScreen(updateUserDetails: _updateUserDetails),
        '/sign-up': (context) => SignUpScreen(updateUserDetails: _updateUserDetails),
        '/profile': (context) => ProfileScreen(username: _username, email: _email, password: _password, profileImage: _profileImage),
      },
    );
  }
}