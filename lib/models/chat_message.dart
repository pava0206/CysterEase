/// Represents a single chat message in the CysterEase AI conversation.
/// Designed to be future-ready for OpenAI or any LLM integration.
class ChatMessage {
  /// The text content of the message.
  final String text;

  /// Whether this message was sent by the user (true) or the bot (false).
  final bool isUser;

  /// When the message was created.
  final DateTime timestamp;

  /// Optional topic tag used for context-aware follow-up suggestions.
  final String? topic;

  /// Optional list of related topic chips to show after a bot response.
  final List<String>? relatedTopics;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.topic,
    this.relatedTopics,
  });
}