import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const BaseLayout({super.key, required this.child, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agriculture App',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                  image: AssetImage('assets/farm-background.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Farm AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Your Smart Farming Assistant',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildDrawerItem(
                    context,
                    Icons.home_rounded,
                    'Home',
                    '/',
                    currentIndex == 0,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.chat_rounded,
                    'Chat with AI',
                    '/chat',
                    currentIndex == 1,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.group_rounded,
                    'Community',
                    '/community',
                    currentIndex == 2,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.person_rounded,
                    'Profile',
                    '/profile',
                    currentIndex == 3,
                  ),
                  Divider(color: Colors.grey.shade300),
                  _buildDrawerItem(
                    context,
                    Icons.login_rounded,
                    'Sign In',
                    '/sign-in',
                    false,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.app_registration_rounded,
                    'Sign Up',
                    '/sign-up',
                    false,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '© 2024 Farm AI',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: child,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_rounded),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey.shade600,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
          elevation: 0,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/');
                break;
              case 1:
                Navigator.pushNamed(context, '/chat');
                break;
              case 2:
                Navigator.pushNamed(context, '/community');
                break;
              case 3:
                Navigator.pushNamed(context, '/profile');
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, String route, bool isSelected) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.green : Colors.grey.shade700,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.green : Colors.grey.shade900,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      tileColor: isSelected ? Colors.green.withOpacity(0.1) : null,
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}