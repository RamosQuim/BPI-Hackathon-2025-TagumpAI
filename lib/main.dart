import 'package:flutter/material.dart';
import 'package:test_app/screens/chatbot.dart';
import 'package:test_app/screens/history.dart';
import 'package:test_app/screens/initial_chatbot.dart';
import 'package:test_app/screens/landing.dart';
import 'package:test_app/screens/login.dart';
import 'package:test_app/screens/onboarding.dart';
import 'package:test_app/screens/profile.dart';
import 'package:test_app/screens/signup.dart';
import 'package:test_app/widgets/navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

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
      initialRoute: '/', // TO-DO: Change the appropriate route for a specific page
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFA42A25),
        // Using Material 3 theming for the Gmail-style navigation bar
        useMaterial3: true,
        // Adding a touch of modern feel with a different splash factory
        splashFactory: InkRipple.splashFactory,
        navigationBarTheme: NavigationBarThemeData(
          // Make the default indicator transparent so we can use our custom one.
          indicatorColor: Colors.transparent,
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                // Style for the selected icon
                return const IconThemeData(color: Color(0xFFA42A25));
              } else {
                // Style for the unselected icon
                return const IconThemeData(color: Colors.grey);
              }
            },
          ),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                // Style for the selected label
                return const TextStyle(
                  fontWeight: FontWeight.w900, // Make it thicker
                  color: Color(0xFFA42A25),   // Set the color
                );
              } else {
                // Style for the unselected label
                return const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w800,
                );
              }
            },
          ),
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          // ···
          titleLarge: GoogleFonts.mulish(fontSize: 24),
          bodyMedium: GoogleFonts.mulish(),
          displaySmall: GoogleFonts.mulish(),
        ),
      ),
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/main': (context) => InitialMainPage(),
        '/history': (context) => HistoryPage(),
        '/profile': (context) => ProfilePage(),
        '/navbar': (context) => MainNavigation(),
      },
    );
  }
}
