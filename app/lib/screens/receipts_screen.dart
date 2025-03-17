import 'package:flutter/material.dart';
import '../widgets/base_layout.dart';

class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      currentIndex: 1,
      child: Center(
        child: Text(
          'AI Chatbox for Receipts',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}