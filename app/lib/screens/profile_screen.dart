import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/base_layout.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    _usernameController = TextEditingController(text: user.username);
    _emailController = TextEditingController(text: user.email);
    _passwordController = TextEditingController(text: user.password);
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      currentIndex: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                  // Handle update profile logic here
                  Provider.of<UserProvider>(context, listen: false).updateUser(
                    _usernameController.text,
                    _emailController.text,
                    _passwordController.text,
                    null,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile updated successfully')),
                  );
                },
                child: Text('Update Profile'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle log out logic here
                  Provider.of<UserProvider>(context, listen: false).clearUser();
                  Navigator.pushNamedAndRemoveUntil(context, '/sign-in', (route) => false);
                },
                child: Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}