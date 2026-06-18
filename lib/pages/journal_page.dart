// lib/pages/journal_page.dart
//
// MODIFIED: same visuals, now wired into XP/mood/unlock system.

import 'package:flutter/material.dart';
import 'dart:math';
import 'stress_service.dart';
import 'mood_checkin.dart';
import 'stress_management.dart' show showActivityReward;

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage>
    with SingleTickerProviderStateMixin {
  final List<String> _prompts = [
    "Write about something that made you smile today.",
    "What is one thing you're grateful for right now?",
    "Describe a challenge you faced and how you overcame it.",
    "What is a positive habit you want to build?",
    "Write a letter to your future self.",
    "How can you show kindness to yourself today?",
    "What's one thing you learned recently?",
    "Reflect on a moment of peace or calm today.",
    "Describe a goal you want to achieve this week.",
    "Write about someone who inspires you.",
    "What is a happy memory from your childhood?",
    "Write a letter of gratitude to someone you've always wanted to thank.",
    "What brings you joy?",
    "What is a simple delight you've enjoyed lately?",
    "In what ways have you grown as a person over the last year?",
    "What is a talent or skill you're grateful to possess?",
    "What are three reasons you are glad to be alive?"
  ];

  int _currentIndex = 0;
  final Random _random = Random();
  int? _moodBefore;
  int _unlockedCount = 5;
  bool _hasEngaged = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _scaleAnimation =
        Tween<double>(begin: 0.97, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
    _loadUnlockState();
    _promptBeforeMood();
  }

  Future<void> _loadUnlockState() async {
    final progress = await StressService.instance.getProgress();
    if (!mounted) return;
    setState(() {
      _unlockedCount = progress.unlockedPrompts.clamp(1, _prompts.length);
    });
  }

  Future<void> _promptBeforeMood() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    final mood = await showMoodPicker(context, prompt: 'How are you feeling right now?');
    if (mounted) setState(() => _moodBefore = mood);
  }

  void _changePrompt(int newIndex) {
    _controller.reverse().then((_) {
      setState(() {
        _currentIndex = newIndex;
        _hasEngaged = true;
      });
      _controller.forward();
    });
  }

  void _showNext() => _changePrompt((_currentIndex + 1) % _unlockedCount);
  void _showPrevious() =>
      _changePrompt((_currentIndex - 1 + _unlockedCount) % _unlockedCount);
  void _showRandom() => _changePrompt(_random.nextInt(_unlockedCount));

  Future<void> _finishSession() async {
    final moodAfter = await showMoodPicker(context, prompt: 'How do you feel now?');
    if (moodAfter != null && _moodBefore != null) {
      await StressService.instance.logMood(
        moodBefore: _moodBefore!,
        moodAfter: moodAfter,
        activity: 'Journal Prompt',
      );
    }
    final result = await StressService.instance.completeActivity(
      xpReward: 15,
      coinReward: 8,
    );
    if (!mounted) return;
    await showActivityReward(context, result);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locked = _prompts.length - _unlockedCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal Prompt"),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.deepPurple,
      ),
      body: AnimatedContainer(
        duration: const Duration(seconds: 3),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade200,
              Colors.purple.shade50,
              Colors.deepPurple.shade100
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                if (locked > 0)
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_outline_rounded,
                            size: 14, color: Colors.deepPurple.shade400),
                        const SizedBox(width: 6),
                        Text(
                          '$locked more prompts unlock as you level up',
                          style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.deepPurple.shade600,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/images/journal1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            _prompts[_currentIndex],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              color: Colors.deepPurple.shade900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildButton(
                      label: "Previous",
                      icon: Icons.arrow_back_ios_new,
                      onPressed: _showPrevious,
                      color: Colors.deepPurple.shade400,
                    ),
                    _buildButton(
                      label: "Random",
                      icon: Icons.auto_awesome,
                      onPressed: _showRandom,
                      color: Colors.deepPurple.shade600,
                    ),
                    _buildButton(
                      label: "Next",
                      icon: Icons.arrow_forward_ios_rounded,
                      onPressed: _showNext,
                      color: Colors.deepPurple.shade400,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (_hasEngaged)
                  TextButton.icon(
                    onPressed: _finishSession,
                    icon: const Icon(Icons.check_circle_outline, color: Colors.deepPurple),
                    label: Text(
                      "I've written my thoughts — claim reward",
                      style: TextStyle(
                          color: Colors.deepPurple.shade700, fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 20),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4,
      ),
    );
  }
}