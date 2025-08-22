import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/widgets/loading.dart';
import 'dart:convert';
import 'dart:math';

// ADDED: Import the model file
import '../models/chat_message_model.dart';

// REMOVED: The ChatMessage class is now in its own file.

class ChatApp extends StatefulWidget {
  // MODIFIED: The widget now requires an initial scenario to be passed to it.
  final ChatMessage initialScenario;

  const ChatApp({
    super.key,
    required this.initialScenario
  });

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  ChatMessage? _currentScenario;
  String? _selectedChoice;
  bool _isWaitingForResponse = false;
  final List<Map<String, String>> _chatHistory = [];
  final String _baseUrl = "http://192.168.100.33:8000";
  late String _backgroundImagePath;

  @override
  void initState() {
    super.initState();
    _currentScenario = widget.initialScenario;

    // Use the new helper method to set the initial image
    _backgroundImagePath = _getNewRandomImagePath();

    if (_currentScenario != null) {
      _chatHistory.add({
        'role': 'CHATBOT',
        'message': _currentScenario!.narrative
      });
    }
  }

  // --- NEW: A reusable method to get a random image path ---
  String _getNewRandomImagePath() {
    // IMPORTANT: Change this number to match how many story images you have.
    const int totalStoryImages = 10;
    final int randomImageNumber = Random().nextInt(totalStoryImages) + 1; // Generates 1 to 5
    return 'assets/images/story$randomImageNumber.jpg';
  }

  Future<void> _submitDecision() async {
    if (_selectedChoice == null) return;

    setState(() {
      _isWaitingForResponse = true;
    });

    try {
      _chatHistory.add({
        'role': 'USER',
        'message': _selectedChoice!
      });

      final storyResponse = await http.post(
        Uri.parse('$_baseUrl/generate-story'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_input': _selectedChoice!,
          'chat_history': _chatHistory
        }),
      );

      if (storyResponse.statusCode == 200 && mounted) {
        final Map<String, dynamic> storyData = json.decode(storyResponse.body);

        if (storyData.containsKey('error')) {
          _showErrorScenario('An error occurred: ${storyData['error']}');
          return;
        }

        final newScenario = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          narrative: storyData['narrative'],
          choices: List<String>.from(storyData['choices']),
          isLoadingImage: true,
        );

        _chatHistory.add({
          'role': 'CHATBOT',
          'message': newScenario.narrative
        });

        // Get a new random image path before updating the state
        final newImagePath = _getNewRandomImagePath();

        setState(() {
          _currentScenario = newScenario;
          _selectedChoice = null;
          _isWaitingForResponse = false;
          _backgroundImagePath = newImagePath; // Update the background image path
        });
      } else {
        if (mounted) {
          _showErrorScenario(
              "Server returned an error: ${storyResponse.statusCode}");
        }
      }
    } catch (e) {
      if (mounted) _showErrorScenario("An error occurred: $e");
    }
  }

  void _showErrorScenario(String errorText) {
    setState(() {
      _currentScenario = ChatMessage(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        narrative: errorText,
        choices: ["Try again"],
      );
      _selectedChoice = null;
      _isWaitingForResponse = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isWaitingForResponse
          ? const AnimatedLoadingIndicator()
          : _currentScenario == null
          ? const Center(child: Text("Loading your story..."))
          : Column(
        children: [
          Expanded(
            child: _buildScenarioPage(_currentScenario!),
          ),
          _buildBottomButton(_currentScenario!),
        ],
      ),
    );
  }

  // ... rest of your code remains the same ...
  Widget _buildScenarioPage(ChatMessage scenario) {
    final bool isStoryFinished = scenario.choices.isEmpty;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          pinned: true,
          expandedHeight: 250.0,
          iconTheme: const IconThemeData(color: Colors.black87),
          flexibleSpace: FlexibleSpaceBar(
            background: Image.asset(
              isStoryFinished ? 'assets/images/success.jpg' : _backgroundImagePath,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.lighten,
            ),
          ),
        ),
        if (isStoryFinished)
          _buildStorySummarySliver(scenario)
        else
          _buildInteractiveStorySliver(scenario),
      ],
    );
  }

  Widget _buildStorySummarySliver(ChatMessage scenario) {
    final List<Map<String, String>> recommendations = [];
    String introText = scenario.narrative;
    String? conclusionText;

    const listDelimiter = "\n\n**";

    if (scenario.narrative.contains(listDelimiter)) {
      final parts = scenario.narrative.split(listDelimiter);
      introText = parts.first.trim();

      for (int i = 1; i < parts.length; i++) {
        final item = parts[i];
        final cardParts = item.split('**: ');

        if (cardParts.length == 2) {
          final title = cardParts[0].trim();
          final content = cardParts[1].trim();

          if (title == "Final Thoughts") {
            conclusionText = content;
          } else {
            recommendations.add({'title': title, 'content': content});
          }
        }
      }
    }

    return SliverPadding(
      padding: const EdgeInsets.all(24.0),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            const Text(
              "Your Story's Conclusion",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 24),
            Text(
              introText,
              style:
              TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
            ),
            const SizedBox(height: 32),
            if (recommendations.isNotEmpty)
              const Text(
                "Key Recommendations",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            const SizedBox(height: 16),
            ...recommendations.map((rec) => _buildRecommendationCard(
              title: rec['title']!,
              content: rec['content']!,
            )),
            if (conclusionText != null && conclusionText.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                "Final Thoughts",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Text(
                conclusionText,
                style: TextStyle(
                    fontSize: 16, color: Colors.grey[700], height: 1.5),
              ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard({required String title, required String content}) {
    const Color primaryRed = Color(0xFFB71C1C);
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_getIconForTitle(title), color: primaryRed, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade800, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('saving') || lowerTitle.contains('investment')) return Icons.savings_outlined;
    if (lowerTitle.contains('risk')) return Icons.trending_up_outlined;
    if (lowerTitle.contains('funding')) return Icons.account_balance_wallet_outlined;
    if (lowerTitle.contains('customer')) return Icons.groups_outlined;
    if (lowerTitle.contains('adaptability')) return Icons.sync_alt_outlined;
    if (lowerTitle.contains('management')) return Icons.calculate_outlined;
    return Icons.lightbulb_outline;
  }

  Widget _buildInteractiveStorySliver(ChatMessage scenario) {
    const Color lightGrey = Color(0xFFF5F5F5);

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: lightGrey,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                scenario.narrative,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ...scenario.choices.map((choice) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: DecisionCard(
                  text: choice,
                  isSelected: _selectedChoice == choice,
                  onTap: () {
                    setState(() {
                      _selectedChoice = choice;
                    });
                  },
                ),
              );
            }).toList(),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: DecisionCard(
                text: 'Finish my story',
                isSelected: _selectedChoice == 'Finish my story',
                onTap: () {
                  setState(() {
                    _selectedChoice = 'Finish my story';
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(ChatMessage scenario) {
    const Color primaryRed = Color(0xFFB71C1C);
    final bool isStoryFinished = scenario.choices.isEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: isStoryFinished
          ? ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: const Text('Return to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      )
          : ElevatedButton(
        onPressed: (_selectedChoice != null && !_isWaitingForResponse) ? _submitDecision : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          minimumSize: const Size(double.infinity, 50),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2,
        ),
        child: const Text('Submit Decision', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class DecisionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const DecisionCard({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFB71C1C);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: isSelected ? primaryRed : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: isSelected ? null : Border.all(color: Colors.grey.shade300, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ]
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 14,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}