import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/community_screen.dart';
import 'providers/user_provider.dart';
import 'providers/post_provider.dart';
import 'providers/plant_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Ensure that the Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load the .env file from the assets directory
  await dotenv.load(fileName: "assets/.env"); // Correct the path if necessary
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => PostProvider()),
        ChangeNotifierProvider(create: (context) => PlantProvider()),
      ],
      child: MaterialApp(
        title: 'Agriculture App',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/sign-in': (context) => SignInScreen(),
          '/sign-up': (context) => SignUpScreen(),
          '/profile': (context) => ProfileScreen(),
          '/chat': (context) => ChatScreen(),
          '/community': (context) => CommunityScreen(),
        },
      ),
    );
  }
}