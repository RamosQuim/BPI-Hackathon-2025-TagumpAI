import 'package:flutter/material.dart';
import 'package:test_app/screens/login.dart';
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
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF135D66),
      ),
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage()
      },
    );
  }
}