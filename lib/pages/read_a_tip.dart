import 'dart:math';
import 'package:flutter/material.dart';

class ReadATipPage extends StatefulWidget {
  const ReadATipPage({super.key});

  @override
  State<ReadATipPage> createState() => _ReadATipPageState();
}

class _ReadATipPageState extends State<ReadATipPage>
    with SingleTickerProviderStateMixin {
  final List<String> _tips = [
    "Take 3 deep breaths — in through your nose, out through your mouth.",
    "Go for a short walk — moving your body releases happy hormones.",
    "Listen to calming music for 5 minutes to reset your mind.",
    "Sip on herbal tea like spearmint or chamomile to relax naturally.",
    "Write down one thing you’re grateful for today.",
    "Stretch your arms and shoulders — release the tension you hold.",
    "Avoid your phone for 10 minutes and just breathe.",
    "Drink enough water — dehydration can increase stress levels.",
    "Say to yourself: ‘I am calm, I am capable, I am enough.’",
    "Sleep early — your body repairs hormones while you rest.",
    "Practice mindful breathing for 5 minutes to reduce cortisol levels.",
    "Do light yoga — especially poses like child's pose and cat-cow to ease tension.",
    "Drink warm water with lemon in the morning to boost digestion and detox.",
    "Eat slowly and without screens — mindful eating supports hormone balance.",
    "Include flaxseeds or chia seeds daily to help regulate estrogen naturally.",
    "Take a short nap if you feel drained — your body heals through rest.",
    "Spend a few minutes in sunlight every morning for vitamin D and mood boost.",
    "Replace sugary snacks with fruits or nuts to prevent insulin spikes.",
    "Take a break from caffeine if you feel anxious — try herbal tea instead.",
    "Try journaling your emotions instead of bottling them up.",
    "Walk barefoot on grass for 5 minutes — grounding helps calm your nervous system.",
    "Do gentle stretching before bed to improve sleep quality.",
    "Keep a gratitude list — positive thoughts reduce stress hormones.",
    "Take magnesium-rich foods like spinach, almonds, and dark chocolate.",
    "Reduce screen time 1 hour before bed — it helps your hormones reset.",
    "Drink spearmint tea twice a week — known to help with PCOS symptoms.",
    "Spend 10 minutes doing something creative — doodle, paint, or sing.",
    "Don’t skip meals — balanced eating prevents hormonal crashes.",
    "Say no to overcommitments — protect your energy and peace.",
    "Celebrate small wins — healing PCOS takes patience and kindness to yourself.",

  ];

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  int _currentIndex = 0;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _scaleAnimation =
        Tween<double>(begin: 0.96, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  void _showRandomTip() {
    _controller.reverse().then((_) {
      setState(() {
        _currentIndex = _random.nextInt(_tips.length);
      });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Read a Tip"),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.deepPurple,
      ),
      body: AnimatedContainer(
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade200,
              Colors.purple.shade50,
              Colors.deepPurple.shade100,
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
                const SizedBox(height: 10),

                // 🌸 Animated Illustration
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      height: 230,
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
                        'assets/images/tip1.png', // 🖼️ Your tip illustration here
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 🪶 Tip Card
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
                            _tips[_currentIndex],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: Colors.deepPurple.shade900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ✨ Button
                ElevatedButton.icon(
                  onPressed: _showRandomTip,
                  icon: const Icon(Icons.auto_awesome, color: Colors.white),
                  label: const Text(
                    "Read a Tip",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade600,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
