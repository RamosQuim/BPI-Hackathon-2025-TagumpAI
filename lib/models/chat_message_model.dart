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