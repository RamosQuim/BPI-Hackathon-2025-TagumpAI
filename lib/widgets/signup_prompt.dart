
// Helper widget for the "Sign Up" prompt
import 'package:flutter/material.dart';
import 'package:test_app/screens/signup.dart';

Widget buildSignUpPrompt(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "Don't have an account? ",
        style: TextStyle(color: Colors.white70),
      ),
      TextButton(
        onPressed: () {
          // Navigate to the Account Setup Page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignupPage()),
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Sign Up',
          style: TextStyle(
            color: Color(0xFF77B0AA), // Use a lighter accent color
            fontWeight: FontWeight.bold,
            fontSize: 16,
            decoration: TextDecoration.underline,
            decorationColor: Color(0xFF77B0AA),
          ),
        ),
      ),
    ],
  );
}