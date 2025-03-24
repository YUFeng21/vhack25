import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/base_layout.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
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
                String email = _emailController.text;
                String password = _passwordController.text;
                UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

                if (userProvider.user.username == username && userProvider.user.email == email && userProvider.user.password == password) {
                  Navigator.pushNamed(context, '/profile');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please sign up, you haven\'t signed in yet')),
                  );
                }
              },
              child: Text('Sign In'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign-up');
              },
              child: Text("Haven't signed up? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}