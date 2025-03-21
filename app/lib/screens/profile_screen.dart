//profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    _fullNameController = TextEditingController(text: user.fullName);
    _usernameController = TextEditingController(text: user.username);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        Provider.of<UserProvider>(
                                  context,
                                ).user.profilePicture !=
                                null
                            ? NetworkImage(
                              Provider.of<UserProvider>(
                                context,
                              ).user.profilePicture!,
                            )
                            : const NetworkImage(
                              'https://via.placeholder.com/150',
                            ), // Default image
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.green),
                      onPressed: () {
                        // Handle profile picture upload
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Profile picture upload coming soon!',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Basic Profile Details
            const Text(
              'Basic Profile Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email Address'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle update profile logic
                Provider.of<UserProvider>(context, listen: false).updateUser(
                  fullName: _fullNameController.text,
                  username: _usernameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  password:
                      _passwordController.text.isNotEmpty
                          ? _passwordController.text
                          : null,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
              },
              child: const Text('Update Profile'),
            ),
            const SizedBox(height: 30),

            // Achievements Section
            const Text(
              'Achievements & Badges',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildBadge('Top Farmer'),
                _buildBadge('Eco-Friendly'),
                _buildBadge('AI Enthusiast'),
              ],
            ),
            const SizedBox(height: 30),

            // Settings & Preferences
            const Text(
              'Settings & Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language & Region'),
              onTap: () {
                // Handle language selection
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Language settings coming soon!'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Settings'),
              onTap: () {
                // Handle notification settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification settings coming soon!'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode / Theme Selection'),
              onTap: () {
                // Handle theme selection
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Theme selection coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Settings'),
              onTap: () {
                // Handle privacy settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Privacy settings coming soon!'),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // Log Out Button
            ElevatedButton(
              onPressed: () {
                // Handle log out logic
                Provider.of<UserProvider>(context, listen: false).clearUser();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/sign-in',
                  (route) => false,
                );
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String title) {
    return Chip(
      label: Text(title),
      avatar: const Icon(Icons.star, color: Colors.yellow),
      backgroundColor: Colors.green[100],
    );
  }
}
