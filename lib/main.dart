import 'package:flutter/material.dart';
import 'package:test_app/screens/chatbot.dart';
import 'package:test_app/screens/history.dart';
import 'package:test_app/screens/login.dart';
import 'package:test_app/screens/profile.dart';
import 'package:test_app/screens/signup.dart';

// You can run this code by placing it in your main.dart file
// or calling LoginPage() from your main App widget.
void main() {
  runApp(const AgapAIApp());
}

class AgapAIApp extends StatelessWidget {
  const AgapAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgapAI',
      initialRoute: '/profile', // TO-DO: Change the appropriate route for a specific page
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF135D66),
      ),
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/main': (context) => const MainPage(),
        '/history': (context) => HistoryPage(),
        '/profile': (context) => ProfilePage()
      },
    );
  }
}