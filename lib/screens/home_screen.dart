import 'package:flutter/material.dart';
import '../widgets/base_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      currentIndex: 0,
      child: Center(
        child: Text(
          'Welcome to the Agriculture App!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}