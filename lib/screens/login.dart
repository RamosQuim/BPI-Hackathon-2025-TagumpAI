import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/social_login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Use a gradient for a visually appealing background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF003C43), // Darker Teal
              Color(0xFF135D66), // Lighter Teal
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Low-fidelity Logo
                const CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Color(0xFFE3FEF7),
                  child: Text(
                    'A',
                    style: TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003C43),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // App Name
                const Text(
                  'AgapAI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8.0),

                // Tagline
                const Text(
                  'Set your goals, see what your future holds.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE3FEF7),
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 72.0),

                // Social Login Buttons (Call-to-Action)
                SocialLoginButton(
                  icon: FontAwesomeIcons.google,
                  label: 'Continue with Google',
                  onPressed: () {
                    // Handle Google login
                  },
                ),
                const SizedBox(height: 16.0),
                SocialLoginButton(
                  icon: FontAwesomeIcons.apple,
                  label: 'Continue with Apple',
                  onPressed: () {
                    // Handle Apple login
                  },
                ),
                const SizedBox(height: 16.0),
                SocialLoginButton(
                  icon: FontAwesomeIcons.facebook,
                  label: 'Continue with Facebook',
                  onPressed: () {
                    // Handle Facebook login
                  },
                ),
                const Spacer(),

                // Legal Text
                const Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}