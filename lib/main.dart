import 'package:flutter/material.dart';
import 'package:test_app/screens/chatbot.dart';
import 'package:test_app/screens/chatbot_sample.dart';
import 'package:test_app/screens/history.dart';
import 'package:test_app/screens/initial_chatbot.dart';
import 'package:test_app/screens/login.dart';
import 'package:test_app/screens/onboarding.dart';
import 'package:test_app/screens/profile.dart';
import 'package:test_app/screens/signup.dart';
import 'package:test_app/widgets/navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// You can run this code by placing it in your main.dart file
// or calling LoginPage() from your main App widget.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: AgapAIApp(),
    ),
  );
}

class AgapAIApp extends StatefulWidget {
  const AgapAIApp({super.key});

  @override
  State<AgapAIApp> createState() => _AgapAIAppState();
}

class _AgapAIAppState extends State<AgapAIApp> {
  bool? isFirstTime;

  @override
  void initState() {
    super.initState();
    checkFirstTime();
  }

  Future<void> checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final firstTime = prefs.getBool('isFirstTime') ?? true;

    // mark as opened after first launch
    if (firstTime) {
      prefs.setBool('isFirstTime', false);
    }

    setState(() {
      isFirstTime = firstTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgapAI',
      home: isFirstTime == null
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ) // wait until prefs load
          : Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                if (isFirstTime!) {
                  return const OnboardingScreen();
                }
                return authProvider.isAuthenticated
                    ? const MainNavigation()
                    : const LoginPage();
              },
            ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFA42A25),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFFFFEECD),
          contentTextStyle: TextStyle(
            fontSize: 14,
            color: Color(0xFFC16306),
          ),

          // 3. (Optional) Set the color for the action button text
          actionTextColor: Colors.white,
        ),
        // Using Material 3 theming for the Gmail-style navigation bar
        useMaterial3: true,
        // Adding a touch of modern feel with a different splash factory
        splashFactory: InkRipple.splashFactory,
        navigationBarTheme: NavigationBarThemeData(
          // Make the default indicator transparent so we can use our custom one.
          indicatorColor: Colors.transparent,
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              // Style for the selected icon
              return const IconThemeData(color: Color(0xFFA42A25));
            } else {
              // Style for the unselected icon
              return const IconThemeData(color: Colors.grey);
            }
          }),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              // Style for the selected label
              return const TextStyle(
                fontWeight: FontWeight.w900, // Make it thicker
                color: Color(0xFFA42A25), // Set the color
              );
            } else {
              // Style for the unselected label
              return const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w800,
              );
            }
          }),
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.mulish(fontSize: 24),
          bodyMedium: GoogleFonts.mulish(),
          displaySmall: GoogleFonts.mulish(),
        ),
      ),
      routes: {
        '/onboard': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/main': (context) => InitialMainPage(),
        // '/chatbot': (context) => ChatApp(),
        '/history': (context) => HistoryPage(),
        '/profile': (context) => ProfilePage(),
        '/navbar': (context) => MainNavigation(),
      },
    );
  }
}
