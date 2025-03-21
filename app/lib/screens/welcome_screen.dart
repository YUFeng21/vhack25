//welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 4;

  final List<Map<String, String>> _tutorialData = [
    {
      'title': 'Welcome to GrowSmart',
      'description': 'Empowering Smart & Sustainable Farming with AI and IoT',
      'image': 'assets/wlc1.png',
    },
    {
      'title': 'Real-Time Monitoring',
      'description':
          'Track soil moisture, pH, temperature, and humidity with IoT sensors',
      'image': 'assets/wlc2.png',
    },
    {
      'title': 'Smart & Sustainable Farming',
      'description':
          'Optimize irrigation and fertilization, use eco-friendly pest control, and leverage AI-powered crop health analysis for precision farming',
      'image': 'assets/wlc3.png',
    },
    {
      'title': 'Community & Social Features',
      'description':
          'Connect with other farmers, share insights, and get expert advice',
      'image': 'assets/wlc4.png',
    },
    {
      'title': 'Let\'s Get Started',
      'description': 'Start your journey today!',
      'image': 'assets/wlc5.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<UserProvider>(context).username;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _numPages,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          _tutorialData[index]['image']!,
                          height: 200,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          index == 0
                              ? 'Welcome, $userName!'
                              : _tutorialData[index]['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFA3C585),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _tutorialData[index]['description']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button on first pages, invisible on last page
                  _currentPage < _numPages - 1
                      ? TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: const Text(
                          'SKIP',
                          style: TextStyle(
                            color: Color(0xFFA3C585),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      : const SizedBox(width: 60),

                  // Page indicator dots
                  Row(
                    children: List.generate(
                      _numPages,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        height: 10,
                        width: _currentPage == index ? 20 : 10,
                        decoration: BoxDecoration(
                          color:
                              _currentPage == index
                                  ? const Color(0xFFA3C585)
                                  : const Color(0xFFCCCCCC),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),

                  // Next or Get Started button
                  _currentPage < _numPages - 1
                      ? ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                        ),
                        child: const Icon(Icons.arrow_forward),
                      )
                      : ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text('GET STARTED'),
                      ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
