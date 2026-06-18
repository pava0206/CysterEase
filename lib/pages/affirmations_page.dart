// lib/pages/affirmations_page.dart
//
// MODIFIED: visual design unchanged, but now wired into the progress
// system. Before-mood is asked on entry; after viewing a few affirmations
// the user can "claim" their session reward, logging the mood shift and
// granting XP/coins. Only unlockedAffirmations count are shown — more
// unlock as the user levels up.

import 'package:flutter/material.dart';
import 'dart:math';
import 'stress_service.dart';
import 'mood_checkin.dart';
import 'stress_management.dart' show showActivityReward;

class AffirmationsPage extends StatefulWidget {
  const AffirmationsPage({super.key});

  @override
  State<AffirmationsPage> createState() => _AffirmationsPageState();
}

class _AffirmationsPageState extends State<AffirmationsPage>
    with SingleTickerProviderStateMixin {
  final List<String> _affirmations = [
    "I am calm, centered, and relaxed.",
    "I trust the process of life.",
    "I am worthy of love and happiness.",
    "I release stress and embrace peace.",
    "I am capable of handling anything.",
    "I radiate positivity and joy.",
    "I am confident and strong.",
    "I am grateful for this moment.",
    "I choose to let go of worries.",
    "I am at peace with myself.",
    "I am allowed to ask for what I want and what I need.",
    "I am allowed to feel good.",
    "I am capable of balancing ease and effort in my life.",
    "I am complete as I am, others simply support me.",
    "I am content and free from pain.",
    "I am doing the work that works for me.",
    "I am good and getting better.",
    "I am growing and going at my own pace.",
    "I am held and supported by those who love me.",
    "I am in charge of how I feel and I choose happiness.",
    "I am listening and open to the universe's messages.",
    "I am loved and worthy.",
    "I am more than my circumstances dictate.",
    "I am open to healing.",
    "I am optimistic because today is a new day.",
    "I am peaceful and whole.",
    "I am proof enough of who I am and what I deserve.",
    "I am responsible for myself, and I start there.",
    "I am safe and surrounded by love and support.",
    "I am still learning — it's okay to make mistakes.",
    "I am understood and my perspective matters.",
    "I am valued and helpful.",
    "I am well-rested and excited for the day.",
    "I am worthy of investing in myself.",
    "I belong here, and I deserve to take up space.",
    "I breathe in healing and exhale pain.",
    "I breathe in trust, I exhale doubt.",
    "I can be soft in my heart and firm in my boundaries.",
    "I celebrate the good qualities in myself and others.",
    "I do not rush through life; I embrace stillness.",
    "I embrace change and rise to new opportunities."
  ];

  int _currentIndex = 0;
  int _viewedCount = 0;
  final Random _random = Random();
  int? _moodBefore;
  int _unlockedCount = 6;

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
    _viewedCount = 1;
    _loadUnlockState();
    _promptBeforeMood();
  }

  Future<void> _loadUnlockState() async {
    final progress = await StressService.instance.getProgress();
    if (!mounted) return;
    setState(() {
      _unlockedCount = progress.unlockedAffirmations.clamp(1, _affirmations.length);
      if (_currentIndex >= _unlockedCount) _currentIndex = 0;
    });
  }

  Future<void> _promptBeforeMood() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    final mood = await showMoodPicker(context, prompt: 'How are you feeling right now?');
    if (mounted) setState(() => _moodBefore = mood);
  }

  void _changeAffirmation(int newIndex) {
    _controller.reverse().then((_) {
      setState(() {
        _currentIndex = newIndex;
        _viewedCount++;
      });
      _controller.forward();
    });
  }

  void _showNext() => _changeAffirmation((_currentIndex + 1) % _unlockedCount);
  void _showPrevious() =>
      _changeAffirmation((_currentIndex - 1 + _unlockedCount) % _unlockedCount);
  void _showRandom() => _changeAffirmation(_random.nextInt(_unlockedCount));

  Future<void> _finishSession() async {
    final moodAfter = await showMoodPicker(context, prompt: 'How do you feel now?');
    if (moodAfter != null && _moodBefore != null) {
      await StressService.instance.logMood(
        moodBefore: _moodBefore!,
        moodAfter: moodAfter,
        activity: 'Affirmations',
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
    final locked = _affirmations.length - _unlockedCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Positive Affirmations"),
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
              Colors.purple.shade100
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
                          '$locked more affirmations unlock as you level up',
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
                            color: Colors.deepPurple.withOpacity(0.25),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/images/affirm1.png',
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
                            _affirmations[_currentIndex],
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
                if (_viewedCount >= 3)
                  TextButton.icon(
                    onPressed: _finishSession,
                    icon: const Icon(Icons.check_circle_outline, color: Colors.deepPurple),
                    label: Text(
                      "I'm done — claim reward",
                      style: TextStyle(
                          color: Colors.deepPurple.shade700, fontWeight: FontWeight.w700),
                    ),
                  )
                else
                  Text(
                    'View ${3 - _viewedCount} more to unlock your reward',
                    style: TextStyle(color: Colors.deepPurple.shade300, fontSize: 12),
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