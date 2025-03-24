import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/receipts_screen.dart';
import 'screens/social_screen.dart';
import 'providers/user_provider.dart';
import 'providers/post_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => PostProvider()),
      ],
      child: MaterialApp(
        title: 'Agriculture App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/sign-in': (context) => SignInScreen(),
          '/sign-up': (context) => SignUpScreen(),
          '/profile': (context) => ProfileScreen(),
          '/receipts': (context) => ReceiptsScreen(),
          '/social': (context) => SocialScreen(),
        },
      ),
    );
  }
}