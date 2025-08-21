import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ADDED: Import the new files
import 'chatbot_sample.dart';
import '../models/chat_message_model.dart';

class InitialMainPage extends StatefulWidget {
  const InitialMainPage({super.key});

  @override
  State<InitialMainPage> createState() => _InitialMainPageState();
}

class _InitialMainPageState extends State<InitialMainPage> {
  // ADDED: Controller for the text field and a loading state
  final TextEditingController _storyController = TextEditingController();
  bool _isLoading = false;

  // ADDED: Define your backend base URL here
  // !!! IMPORTANT: Replace with your computer's local IP address !!!
  final String _baseUrl = "http://192.168.100.33:8000";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _storyController.dispose(); // ADDED: Dispose the controller
    super.dispose();
  }

  // Colors extracted from the UI screenshot
  static const Color _primaryRed = Color(0xFFA42A25);
  static const Color _cardBgColor = Color(0xFFF5F5F5);
  static const Color _darkTextColor = Color(0xFF222222);
  static const Color _lightTextColor = Color(0xFF494949);

  // --- ADDED: API and Navigation Logic ---
  Future<void> _startStory(String prompt) async {
    if (prompt.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a story idea.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/generate-story'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_input': prompt,
          'initial_prompt': prompt,
          'chat_history': []
        }),
      );

      if (response.statusCode == 200 && mounted) {
        // --- MODIFIED: Simplified parsing logic ---
        // 1. Decode the JSON response body directly into a Map ONE TIME.
        final Map<String, dynamic> storyData = json.decode(response.body);

        // 2. Check for an error key within the decoded map.
        if (storyData.containsKey('error')) {
          throw Exception('Backend error: ${storyData['error']}');
        }

        // 3. Create the ChatMessage object from the map.
        final initialScenario = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          narrative: storyData['narrative'],
          choices: List<String>.from(storyData['choices']),
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatApp(initialScenario: initialScenario),
          ),
        );
      } else {
        throw Exception(
            'Failed to start story. Status code: ${response.statusCode}. Body: ${response.body}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryRed,
      body: Stack( // MODIFIED: Added Stack to show a loading indicator
        children: [
          CustomScrollView(
            slivers: [_buildSliverAppBar(), _buildContentSection()],
          ),
          // ADDED: Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
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
          'assets/images/agapai_logo_white.png',
          height: 30, // A more reasonable height for an AppBar
        ),
      ),
      expandedHeight: 235.0,
      automaticallyImplyLeading: false,
      elevation: 0,
      pinned:
      true, // The app bar will remain visible at the top when collapsed.
      flexibleSpace: FlexibleSpaceBar(
        // The background of the flexible space bar.
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Placeholder for the background image pattern in the screenshot.
            // A simple gradient is used here.
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Color(0xFF510300),
                BlendMode.overlay,
              ),
              child: Image.asset(
                'assets/images/chatbot_background.png',
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
                        FontVariation(
                          'wght',
                          1000.0,
                        ), // Example: A weight beyond 900
                      ],
                      height: 1.15,
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
              // MODIFIED: Story suggestion cards now have real text and are tappable
              _buildSuggestionCard(
                title: 'What if I start a small coffee cart?',
                description: 'Explore the journey of turning a passion for coffee into a mobile business venture.',
              ),
              const SizedBox(height: 12),
              _buildSuggestionCard(
                title: 'What if I invest in a local franchise?',
                description: 'Dive into the pros and cons of buying into an established brand versus starting from scratch.',
              ),
              const SizedBox(height: 12),
              _buildSuggestionCard(
                title: 'What if I expand my online shop?',
                description: 'Navigate the challenges of scaling up, from marketing and logistics to managing inventory.',
              ),
              const SizedBox(height: 32),
              _buildStoryInput(),
            ],
          ),
        ),
      ),
    );
  }

  // MODIFIED: Now takes text and is wrapped in a GestureDetector
  Widget _buildSuggestionCard({required String title, required String description}) {
    return GestureDetector(
      onTap: () => _startStory(title),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: _cardBgColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _darkTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: _lightTextColor, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

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
          controller: _storyController, // MODIFIED: Assigned controller
          decoration: InputDecoration(
            hintText: "Type your own 'what-if' below.",
            hintStyle: const TextStyle(color: _lightTextColor),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Padding(
              padding: const EdgeInsets.all(7.0),
              // MODIFIED: Wrapped icon in a tappable widget
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onTap: () => _startStory(_storyController.text),
                child: Container(
                  decoration: BoxDecoration(
                    color: _primaryRed,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}