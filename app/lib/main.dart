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
        theme: ThemeData(
          primaryColor: const Color(0xFFA3C585),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFA3C585),
            primary: const Color(0xFFA3C585),
            secondary: const Color(0xFF0B6E4F),
          ),
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA3C585),
              foregroundColor: Colors.white,
            ),
          ),
        ),
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
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCECCF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 150),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA3C585)),
            ),
          ],
        ),
      ),
    );
  }
}
