import 'package:flutter/material.dart';
import 'package:cysterease/models/chat_message.dart';
import 'package:cysterease/services/chat_service.dart';

/// CysterEase AI Chatbot — modern, wellness-coach-style chat interface.
/// Architecture is future-ready: swap [ChatService] for any LLM implementation
/// via [BaseChatService] without touching this UI file.
class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage>
    with TickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocus = FocusNode();

  /// Swap this with OpenAIChatService() or any other implementation later.
  final BaseChatService _chatService = ChatService();

  final List<ChatMessage> _messages = [];

  bool _isTyping = false;
  String? _lastTopic;

  // Animation controller for the typing indicator dots
  late AnimationController _dotAnimController;

  // ── Quick action chips shown in the header ──────────────────────
  static const List<Map<String, String>> _quickActions = [
    {'emoji': '🥗', 'label': 'Diet', 'query': 'What should I eat for PCOS?'},
    {'emoji': '😴', 'label': 'Sleep', 'query': 'How can I improve my sleep with PCOS?'},
    {'emoji': '🧘', 'label': 'Stress', 'query': 'How do I manage stress with PCOS?'},
    {'emoji': '🌸', 'label': 'PCOS', 'query': 'Tell me about PCOS'},
    {'emoji': '💪', 'label': 'Exercise', 'query': 'What exercises are good for PCOS?'},
    {'emoji': '🤰', 'label': 'Fertility', 'query': 'How does PCOS affect fertility?'},
    {'emoji': '📅', 'label': 'Periods', 'query': 'Why are my periods irregular with PCOS?'},
    {'emoji': '😊', 'label': 'Mood', 'query': 'I have mood swings because of PCOS'},
    {'emoji': '🍫', 'label': 'Cravings', 'query': 'Why do I have sugar cravings with PCOS?'},
  ];

  @override
  void initState() {
    super.initState();

    _dotAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Initial welcome message
    _messages.add(
      ChatMessage(
        text:
            "Hello! I'm CysterEase AI 💜\n\n"
            "I'm here as your personal PCOS wellness companion — think of me as a supportive friend who happens to know a lot about hormones, nutrition, and self-care! 🌸\n\n"
            "I can help you with diet, sleep, stress, exercise, periods, fertility, and so much more.\n\n"
            "What's on your mind today?",
        isUser: false,
        timestamp: DateTime.now(),
        relatedTopics: ['PCOS', 'Diet', 'Stress'],
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _inputFocus.dispose();
    _dotAnimController.dispose();
    super.dispose();
  }

  // ── SEND MESSAGE ────────────────────────────────────────────────

  Future<void> _sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isTyping) return;

    _inputController.clear();
    _inputFocus.unfocus();

    setState(() {
      _messages.add(ChatMessage(
        text: trimmed,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _scrollToBottom();

    final response = await _chatService.getResponse(
      trimmed,
      lastTopic: _lastTopic,
    );

    if (!mounted) return;

    setState(() {
      _lastTopic = response.topic;
      _messages.add(response);
      _isTyping = false;
    });

    _scrollToBottom(delay: 100);
  }

  void _scrollToBottom({int delay = 0}) {
    Future.delayed(Duration(milliseconds: delay), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── BUILD ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildDisclaimerBanner(),
          _buildQuickActionChips(),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEDE7F6)),
          Expanded(child: _buildMessageList()),
          if (_isTyping) _buildTypingIndicator(),
          _buildInputBar(),
        ],
      ),
    );
  }

  // ── APP BAR ──────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          // Bot avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade300,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CysterEase AI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                'Your wellness companion 💜',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── DISCLAIMER ───────────────────────────────────────────────────

  Widget _buildDisclaimerBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      color: Colors.deepPurple.shade50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              size: 15, color: Colors.deepPurple.shade400),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              'This assistant provides educational information only and is not a substitute for professional medical advice.',
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.deepPurple.shade400,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── QUICK ACTION CHIPS ───────────────────────────────────────────

  Widget _buildQuickActionChips() {
    return Container(
      height: 50,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _quickActions.length,
        itemBuilder: (context, index) {
          final action = _quickActions[index];
          return _QuickChip(
            emoji: action['emoji']!,
            label: action['label']!,
            onTap: () => _sendMessage(action['query']!),
          );
        },
      ),
    );
  }

  // ── MESSAGE LIST ─────────────────────────────────────────────────

  Widget _buildMessageList() {
    if (_messages.isEmpty) return _buildEmptyState();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isFirst = index == 0;
        final showAvatar = !message.isUser &&
            (index == 0 || _messages[index - 1].isUser);

        return _MessageBubble(
          message: message,
          showAvatar: showAvatar,
          isFirst: isFirst,
          onChipTap: _sendMessage,
        );
      },
    );
  }

  // ── EMPTY STATE ──────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded,
              size: 60, color: Colors.deepPurple.shade200),
          const SizedBox(height: 14),
          Text(
            'Start a conversation 💜',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple.shade300,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap a topic above or type your question',
            style: TextStyle(fontSize: 13, color: Colors.deepPurple.shade200),
          ),
        ],
      ),
    );
  }

  // ── TYPING INDICATOR ─────────────────────────────────────────────

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Row(
        children: [
          _botAvatar(size: 28),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _TypingDots(controller: _dotAnimController),
          ),
        ],
      ),
    );
  }

  // ── INPUT BAR ────────────────────────────────────────────────────

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              focusNode: _inputFocus,
              maxLines: 3,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: _sendMessage,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Ask anything about PCOS...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.deepPurple.shade50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(
                    color: Colors.deepPurple.shade300,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _SendButton(
            onTap: () => _sendMessage(_inputController.text),
            isLoading: _isTyping,
          ),
        ],
      ),
    );
  }

  // ── HELPERS ──────────────────────────────────────────────────────

  Widget _botAvatar({double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.support_agent_rounded,
        color: Colors.white,
        size: size * 0.55,
      ),
    );
  }
}

// ── MESSAGE BUBBLE ───────────────────────────────────────────────────────────

/// Renders a single chat bubble with optional bot avatar, timestamp, and
/// related topic chips for bot messages.
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showAvatar;
  final bool isFirst;
  final void Function(String) onChipTap;

  const _MessageBubble({
    required this.message,
    required this.showAvatar,
    required this.isFirst,
    required this.onChipTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: showAvatar ? 12 : 3,
        bottom: 2,
      ),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Bot avatar (only on first message in a bot sequence)
              if (!isUser)
                Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 4),
                  child: showAvatar
                      ? _avatar()
                      : const SizedBox(width: 32), // spacer to align
                ),

              // Bubble
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Colors.deepPurple
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white
                          : Colors.grey.shade800,
                      fontSize: 14.5,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Timestamp
          Padding(
            padding: EdgeInsets.only(
              left: isUser ? 0 : 48,
              right: isUser ? 4 : 0,
              top: 3,
              bottom: 2,
            ),
            child: Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10.5,
                color: Colors.grey.shade400,
              ),
            ),
          ),

          // Related Topics chips (bot only)
          if (!isUser &&
              message.relatedTopics != null &&
              message.relatedTopics!.isNotEmpty)
            _buildRelatedTopics(message.relatedTopics!),
        ],
      ),
    );
  }

  Widget _avatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.support_agent_rounded,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  Widget _buildRelatedTopics(List<String> topics) {
    return Padding(
      padding: const EdgeInsets.only(left: 48, top: 6, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Related Topics:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple.shade300,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 5),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: topics.map((topic) {
              return _RelatedChip(
                label: topic,
                onTap: () => onChipTap(topic),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

// ── QUICK CHIP ───────────────────────────────────────────────────────────────

/// A compact emoji + label chip for the quick actions bar.
class _QuickChip extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _QuickChip({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.deepPurple.shade200, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── RELATED CHIP ─────────────────────────────────────────────────────────────

/// A chip shown below bot messages to suggest related topics.
class _RelatedChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _RelatedChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.deepPurple.shade200, width: 1),
        ),
        child: Text(
          '• $label',
          style: TextStyle(
            fontSize: 11.5,
            color: Colors.deepPurple.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ── SEND BUTTON ──────────────────────────────────────────────────────────────

/// Animated send button that shows a loading spinner while the bot is typing.
class _SendButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const _SendButton({required this.onTap, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isLoading
              ? Colors.deepPurple.shade200
              : Colors.deepPurple,
          boxShadow: [
            if (!isLoading)
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(13),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
      ),
    );
  }
}

// ── TYPING DOTS ──────────────────────────────────────────────────────────────

/// Animated three-dot typing indicator rendered inside a chat bubble.
class _TypingDots extends StatelessWidget {
  final AnimationController controller;

  const _TypingDots({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            // Stagger each dot's animation by 200ms
            final delay = i * 0.25;
            final t = ((controller.value + delay) % 1.0);
            final opacity = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.3, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}