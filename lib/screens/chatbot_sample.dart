import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  // ADDED: A list to maintain the full conversation history.
  final List<Map<String, String>> _chatHistory = [];

  final String _baseUrl = "http://192.168.100.33:8000";

  @override
  void initState() {
    super.initState();
    _currentScenario = widget.initialScenario;

    if (_currentScenario != null) {
      // ADDED: Start the history with the initial story narrative from the AI.
      _chatHistory.add({
        'role': 'CHATBOT',
        'message': _currentScenario!.narrative
      });
    }
  }

  // --- API CALL LOGIC ---
  Future<void> _submitDecision() async {
    if (_selectedChoice == null) return;

    setState(() {
      _isWaitingForResponse = true;
    });

    try {
      // ADDED: Add the user's selected choice to the history before the API call.
      _chatHistory.add({
        'role': 'USER',
        'message': _selectedChoice!
      });

      final storyResponse = await http.post(
        Uri.parse('$_baseUrl/generate-story'),
        headers: {'Content-Type': 'application/json'},
        // MODIFIED: Send the complete chat history.
        body: json.encode({
          'user_input': _selectedChoice!,
          'chat_history': _chatHistory
        }),
      );

      if (storyResponse.statusCode == 200 && mounted) {
        // --- MODIFIED: Simplified parsing logic ---
        // 1. Decode the JSON response body directly into a Map ONE TIME.
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

        // ADDED: Add the AI's new response to the history.
        _chatHistory.add({
          'role': 'CHATBOT',
          'message': newScenario.narrative
        });

        setState(() {
          _currentScenario = newScenario;
          _selectedChoice = null;
          _isWaitingForResponse = false;
        });

        // You can re-enable image generation here if you wish
        // _generateAndSetImage(newScenario.id, newScenario.narrative);

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

  // ... the rest of your _ChatAppState class remains the same ...
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
    const Color primaryRed = Color(0xFFB71C1C);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true, // Set to true to show back button
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Image.asset(
            'assets/images/agapai_logo.png',
            height: 30,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: _isWaitingForResponse
          ? const Center(child: CircularProgressIndicator(color: primaryRed,))
          : _currentScenario == null
          ? const Center(child: Text("Loading your story..."))
          : _buildScenarioPage(_currentScenario!),
    );
  }

  // --- MODIFIED: This widget now handles both states ---
  Widget _buildScenarioPage(ChatMessage scenario) {
    const Color primaryRed = Color(0xFFB71C1C);
    const Color lightGrey = Color(0xFFF5F5F5);

    // This boolean checks if the story is over.
    final bool isStoryFinished = scenario.choices.isEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            // Show a different title for the final screen
            isStoryFinished ? 'Your Financial Summary' : 'Your Financial Story',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: primaryRed,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
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

          // --- LOGIC CHANGE: Conditionally show choices or a restart button ---
          if (isStoryFinished)
          // If the story is finished, show the "Start New Story" button
            ElevatedButton(
              onPressed: () {
                // Navigate back to the screen with the route name '/navbar'.
                // This pops all routes until it finds the '/navbar' route.
                Navigator.of(context).popUntil((route) => route.settings.name == '/navbar');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Start a New Story',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          else
          // If the story is ongoing, show the choices and the submit button
            Column(
              children: [
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

                // ADDED: Always include the "Finish my story" option
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

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: (_selectedChoice != null && !_isWaitingForResponse) ? _submitDecision : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Submit Decision',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class DecisionCard extends StatelessWidget {
  // ... No changes needed here
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
          // Change color and border based on selection state
            color: isSelected ? primaryRed : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: isSelected ? null : Border.all(color: Colors.grey.shade300, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2),
              )
            ]
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            // Change text color based on selection state
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