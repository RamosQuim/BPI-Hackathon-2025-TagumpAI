import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms and Conditions',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
This is a placeholder for the Terms and Conditions.

1. Introduction
   This section will outline the purpose and scope of the terms.

2. User Obligations
   This will include rules users must follow while using the app.

3. Data Privacy
   We will describe how user data is collected, stored, and used.

4. Modifications
   Information about how and when these terms may be updated.

5. Contact Information
   Where users can reach out for support or questions.

Please replace this placeholder content with the final version of your Terms and Conditions before launching your application.
            ''',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
