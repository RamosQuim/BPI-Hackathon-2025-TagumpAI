import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InitialMainPage extends StatefulWidget {
  const InitialMainPage({super.key});

  @override
  State<InitialMainPage> createState() => _InitialMainPageState();
}

class _InitialMainPageState extends State<InitialMainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  // State for the currently selected index in the BottomNavigationBar
  int _selectedIndex = 1;

  // Colors extracted from the UI screenshot
  static const Color _primaryRed = Color(0xFFA42A25);
  static const Color _cardBgColor = Color(0xFFF5F5F5);
  static const Color _darkTextColor = Color(0xFF222222);
  static const Color _lightTextColor = Color(0xFF494949);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background color of the scaffold is set to the primary red.
      // This color will be visible at the top (behind the status bar)
      // and during over-scrolling.
      backgroundColor: _primaryRed,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          _buildContentSection(),
        ],
      ),
    );
  }

  /// Builds the top collapsing app bar section.
  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      title: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(10, 0, 10, 0),
          child: Image.asset(
            'images/agapai_logo_white.png',
          height: 30, // A more reasonable height for an AppBar
        )
      ),
      expandedHeight: 235.0,
      automaticallyImplyLeading: false,
      elevation: 0,
      pinned: true, // The app bar will remain visible at the top when collapsed.
      flexibleSpace: FlexibleSpaceBar(
        // The background of the flexible space bar.
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Placeholder for the background image pattern in the screenshot.
            // A simple gradient is used here.
            ColorFiltered(
              colorFilter: const ColorFilter.mode(Color(0xFF510300), BlendMode.overlay),
              child: Image.asset(
                'images/chatbot_background.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryRed, Color(0xFF510300).withOpacity(0.55)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            // The content of the expanded app bar.
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Headline Text
                  const Text(
                    'Ready to see your future?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontVariations: [
                        FontVariation('wght', 1000.0), // Example: A weight beyond 900
                      ],
                      height: 1.15
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Sub-headline Text
                  Text(
                    "Let us explore your 'what-if' story!",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the main scrollable content area with the white background.
  SliverToBoxAdapter _buildContentSection() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Story Suggestions For You',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _primaryRed,
                ),
              ),
              const SizedBox(height: 16),
              // Story suggestion cards
              _buildSuggestionCard(),
              const SizedBox(height: 12),
              _buildSuggestionCard(),
              const SizedBox(height: 12),
              _buildSuggestionCard(),
              const SizedBox(height: 32),
              // User input section
              _buildStoryInput(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a single story suggestion card.
  Widget _buildSuggestionCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _cardBgColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lorem ipsum?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _darkTextColor,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            style: TextStyle(
              fontSize: 14,
              color: _lightTextColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the "Got a story in mind?" text input field.
  Widget _buildStoryInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Got a story in mind?',
          style: TextStyle(
            color: _primaryRed,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: "Type your own 'what-if' below.",
            hintStyle: const TextStyle(color: _lightTextColor),
            filled: true,
            fillColor: Colors.white,
            // Custom suffix icon with background color and rounded corners
            suffixIcon: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Container(
                decoration: BoxDecoration(
                  color: _primaryRed,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: const BorderSide(color: _primaryRed, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}