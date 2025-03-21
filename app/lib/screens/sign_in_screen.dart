//sign_in_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String username = _usernameController.text;
                String email = _emailController.text;
                String password = _passwordController.text;
                UserProvider userProvider = Provider.of<UserProvider>(
                  context,
                  listen: false,
                );

                if (userProvider.user.username == username &&
                    userProvider.user.email == email &&
                    userProvider.user.password == password) {
                  Navigator.pushNamed(context, '/profile');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please sign up, you haven\'t signed in yet',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign-up');
              },
              child: const Text("Haven't signed up? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
