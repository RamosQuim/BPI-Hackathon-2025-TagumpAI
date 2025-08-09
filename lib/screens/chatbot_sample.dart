import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// --- DATA MODEL for a chat message ---
class ChatMessage {
  final String id;
  final String narrative;
  final List<String> choices;
  String? imageUrl_base64; // Can be null initially
  bool isLoadingImage;

  ChatMessage({
    required this.id,
    required this.narrative,
    required this.choices,
    this.imageUrl_base64,
    this.isLoadingImage = false,
  });
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgapAI Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // --- STATE ---
  final List<ChatMessage> _messages = [];
  bool _isWaitingForResponse = false;

  // !!! IMPORTANT: Replace with your computer's local IP address !!!
  final String _baseUrl = "http://192.168.100.33:8000";

  @override
  void initState() {
    super.initState();
    // Add the initial message to start the story
    _addInitialMessage();
  }

  void _addInitialMessage() {
    setState(() {
      _messages.add(
        ChatMessage(
          id: '0',
          narrative: 'Hi! I am AgapAI. Let\'s explore a financial scenario together.',
          choices: ["Let's start!"],
        ),
      );
    });
  }

  // --- API CALL LOGIC ---
  Future<void> _handleUserChoice(String choiceText) async {
    setState(() {
      _isWaitingForResponse = true;
    });

    try {
      final storyResponse = await http.post(
        Uri.parse('$_baseUrl/generate-story'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_input': choiceText, 'chat_history': []}),
      );

      if (storyResponse.statusCode == 200) {
        print("Raw server response: ${storyResponse.body}");

        // --- START: ROBUST JSON PARSING ---

        // 1. Decode the outer string to get the inner string content.
        String innerString = json.decode(storyResponse.body);

        // 2. Clean the inner string to remove markdown fences from the AI.
        if (innerString.startsWith("```json")) {
          innerString = innerString.substring(7); // Remove the starting ```json
        }
        if (innerString.endsWith("```")) {
          innerString = innerString.substring(0, innerString.length - 3);
        }
        innerString = innerString.trim(); // Remove any extra whitespace.

        // 3. Decode the cleaned inner string to get the final Map object.
        final Map<String, dynamic> storyData = json.decode(innerString);

        print("Successfully parsed data: $storyData");

        // --- END: ROBUST JSON PARSING ---

        // Check for a logical error sent by the server.
        if (storyData.containsKey('error')) {
          setState(() {
            _messages.add(
              ChatMessage(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                narrative: 'An error occurred: ${storyData['error']}',
                choices: [],
              ),
            );
            _isWaitingForResponse = false;
          });
          return; // Stop execution here
        }

        // If no error, proceed to create the message.
        final newMessageId = DateTime.now().millisecondsSinceEpoch.toString();
        final newChatMessage = ChatMessage(
          id: newMessageId,
          narrative: storyData['narrative'],
          choices: List<String>.from(storyData['choices']),
          isLoadingImage: true,
        );

        setState(() {
          _messages.add(newChatMessage);
          _isWaitingForResponse = false;
        });

        _generateAndSetImage(newMessageId, newChatMessage.narrative);

      } else {
        print("Server returned an error: ${storyResponse.statusCode}");
        setState(() {
          _isWaitingForResponse = false;
        });
      }
    } catch (e) {
      print("An error occurred during decoding or network call: $e");
      setState(() {
        _isWaitingForResponse = false;
      });
    }
  }

  Future<void> _generateAndSetImage(String messageId, String prompt) async {
    try {
      final imageResponse = await http.post(
        Uri.parse('$_baseUrl/generate-image'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'prompt': prompt}),
      );

      if (imageResponse.statusCode == 200) {
        final imageData = json.decode(imageResponse.body);
        setState(() {
          // Find the message by its ID and update it
          final messageIndex = _messages.indexWhere((m) => m.id == messageId);
          if (messageIndex != -1) {
            _messages[messageIndex].imageUrl_base64 = imageData['imageUrl_base64'];
            _messages[messageIndex].isLoadingImage = false; // IMPORTANT: Set loading to false
          }
        });
      }
    } catch (e) {
      // Handle image generation error silently or show a placeholder
      print("Image generation failed: $e");
    }
  }

  // --- UI BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgapAI Financial Story'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildChatMessageCard(message);
              },
            ),
          ),
          if (_isWaitingForResponse)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildChatMessageCard(ChatMessage message) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- The Image section ---
            if (message.isLoadingImage)
              const Center(child: CircularProgressIndicator())
            else if (message.imageUrl_base64 != null)
              Image.memory(base64Decode(message.imageUrl_base64!)),

            const SizedBox(height: 10),

            // --- The Narrative text ---
            Text(
              message.narrative,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),

            // --- The Choice buttons ---
            if (!_isWaitingForResponse && message.choices.isNotEmpty)
              ...message.choices.map((choice) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 8),
                  child: ElevatedButton(
                    onPressed: () => _handleUserChoice(choice),
                    child: Text(choice),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}