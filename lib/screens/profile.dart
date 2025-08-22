import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/screens/profile_personal_info.dart';

// --- ACCOUNT PAGE (Profile) ---
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/agapai_logo.png', height: 30),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage("assets/icons/profile.png"), // dummy profile
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Juan Dela Cruz",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4,),
                    Text("juandelacruz@gmail.com",
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Discover Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFA42A25),
                borderRadius: BorderRadius.circular(24),
                // --- SHADOW ADDED HERE ---
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/premium.png',
                    width: 70,
                    height: 70,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      // Aligns the text to the left
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Discover BPI products",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 18, // Adjusted font size for better fit
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4), // Adds space between the texts
                        const Text(
                          "Choose what suits your lifestyle",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.chevron_right, color: Colors.white,)
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text("General", style: TextStyle(color: Colors.grey)),
            ListTile(
              leading: const Icon(Icons.person_outline_rounded),
              title: const Text("Personal Info", style: TextStyle(fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  // Replace MaterialPageRoute with PageRouteBuilder
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const PersonalInfoPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      // Define the start and end positions for the slide
                      const begin = Offset(-1.0, 0.0); // Start from the bottom
                      const end = Offset.zero; // End at the original position (no offset)
                      const curve = Curves.easeInOut;

                      // Create the animation tween
                      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      final offsetAnimation = animation.drive(tween);

                      // Return the SlideTransition widget
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400), // Optional: Adjust speed
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Language", style: TextStyle(fontWeight: FontWeight.w500)),
              trailing: const Text("English (Philippines)"),
            ),

            const SizedBox(height: 16),
            const Text("About", style: TextStyle(color: Colors.grey)),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("Help Center", style: TextStyle(fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline_rounded),
              title: const Text("Privacy Policy", style: TextStyle(fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About AgapAI", style: TextStyle(fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Color(0xFFA42A25)),
              title: const Text("Logout",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}