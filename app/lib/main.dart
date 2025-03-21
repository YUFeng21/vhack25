//main dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/social_screen.dart';
import 'screens/my_farm_screen.dart';
import 'screens/my_crops_screen.dart';
import 'screens/smart_irrigation_screen.dart';
import 'screens/pest_control_screen.dart';
import 'screens/precision_farming_screen.dart';
import 'screens/crop_health_screen.dart';
import 'providers/farm_data_provider.dart';
import 'providers/user_provider.dart';
import 'providers/post_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => PostProvider()),
        ChangeNotifierProvider(create: (context) => FarmDataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: const Color(0xFFA3C585)),
        home: const SplashScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/farm': (context) => const MyFarmScreen(),
          '/crops': (context) => const MyCropsScreen(),
          '/agribot': (context) => const ChatbotScreen(),
          '/agrifriend': (context) => const SocialScreen(),
          '/sign-in': (context) => SignInScreen(),
          '/sign-up': (context) => const SignUpScreen(),
          '/smart_irrigation': (context) => const SmartIrrigationScreen(),
          '/pest_control': (context) => const PestControlScreen(),
          '/precision_farming': (context) => const PrecisionFarmingScreen(),
          '/crop_health': (context) => const CropHealthScreen(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the main app after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDCECCF), // Set background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 150), // App logo
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
