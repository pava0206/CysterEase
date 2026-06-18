// lib/pages/stress_management.dart
//
// REWRITE of the original card-carousel hub into a "calm journey" map.
// Same purple theme, same four destinations (Affirmations, Breathing/
// Meditation, Journal, Tips) — but now wrapped in a progress system:
// streaks, levels, coins, and a path layout that visually represents
// growth. The goal is to give people a REASON to open this section
// when stressed, and a reason to come back the next day too.

import 'package:flutter/material.dart';
import 'stress_service.dart';
import 'affirmations_page.dart';
import 'meditation_page.dart';
import 'journal_page.dart';
import 'read_a_tip.dart';
import 'mood_checkin.dart';

class StressManagementPage extends StatefulWidget {
  const StressManagementPage({super.key});

  @override
  State<StressManagementPage> createState() => _StressManagementPageState();
}

class _StressManagementPageState extends State<StressManagementPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Your Calm Space'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart_rounded),
            tooltip: 'Mood trend',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MoodTrendPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<StressProgress>(
        stream: StressService.instance.watchProgress(),
        builder: (context, snapshot) {
          final progress = snapshot.data ?? const StressProgress();

          return FadeTransition(
            opacity: _entranceController,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatsHeader(progress: progress),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Text(
                      "Pick a path to calm",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _JourneyMap(progress: progress),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Stats Header ─────────────────────────────────────────────────────────

class _StatsHeader extends StatelessWidget {
  final StressProgress progress;
  const _StatsHeader({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 26),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A1B9A), Color(0xFF9C27B0), Color(0xFFCE93D8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.35)),
                ),
                child: Center(
                  child: Text(
                    'L${progress.level}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level ${progress.level} · Calm Seeker',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress.levelProgress,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation(Colors.amber),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${progress.xpIntoLevel} / ${progress.xpForNextLevel} XP to next level',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _StatPill(
                icon: Icons.local_fire_department_rounded,
                iconColor: Colors.orangeAccent,
                label: '${progress.streakCount}-day streak',
              ),
              const SizedBox(width: 10),
              _StatPill(
                icon: Icons.monetization_on_rounded,
                iconColor: Colors.amber,
                label: '${progress.coins} coins',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  const _StatPill({required this.icon, required this.iconColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ── Journey Map ───────────────────────────────────────────────────────────

class _JourneyNode {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final Widget Function() pageBuilder;
  final String? badge;

  _JourneyNode({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.pageBuilder,
    this.badge,
  });
}

class _JourneyMap extends StatelessWidget {
  final StressProgress progress;

  const _JourneyMap({required this.progress});

  @override
  Widget build(BuildContext context) {
    // Base unlock counts a brand-new user starts with (mirrors the
    // defaults in StressProgress). Anything above these means the user
    // has leveled up and earned extra content in that category.
    const baseAffirmations = 6;
    const basePrompts = 5;
    const baseTips = 8;

    final breathingBadge = progress.bestBreathingScore > 0
        ? 'Best: ${progress.bestBreathingScore}'
        : null;
    final affirmationsBadge =
        progress.unlockedAffirmations > baseAffirmations ? 'New unlocked' : null;
    final journalBadge =
        progress.unlockedPrompts > basePrompts ? 'New unlocked' : null;
    final tipsBadge = progress.unlockedTips > baseTips ? 'New unlocked' : null;

    final nodes = [
      _JourneyNode(
        title: 'Breathing Journey',
        subtitle: 'Calm your body, score your rhythm',
        icon: Icons.air_rounded,
        colors: const [Color(0xFF6A1B9A), Color(0xFF38006B)],
        pageBuilder: () => const MeditationPage(),
        badge: breathingBadge,
      ),
      _JourneyNode(
        title: 'Affirmations',
        subtitle: 'Rewire your thoughts',
        icon: Icons.favorite_rounded,
        colors: const [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
        pageBuilder: () => const AffirmationsPage(),
        badge: affirmationsBadge,
      ),
      _JourneyNode(
        title: 'Journal Prompt',
        subtitle: 'Reflect & release',
        icon: Icons.edit_note_rounded,
        colors: const [Color(0xFF7B1FA2), Color(0xFF4A148C)],
        pageBuilder: () => const JournalPage(),
        badge: journalBadge,
      ),
      _JourneyNode(
        title: 'Read a Tip',
        subtitle: 'A small shift, right now',
        icon: Icons.tips_and_updates_rounded,
        colors: const [Color(0xFF8E24AA), Color(0xFF5E1688)],
        pageBuilder: () => const ReadATipPage(),
        badge: tipsBadge,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(nodes.length, (i) {
          final node = nodes[i];
          final isLast = i == nodes.length - 1;
          return _JourneyNodeTile(
            node: node,
            index: i,
            isLast: isLast,
          );
        }),
      ),
    );
  }
}

class _JourneyNodeTile extends StatefulWidget {
  final _JourneyNode node;
  final int index;
  final bool isLast;

  const _JourneyNodeTile({
    required this.node,
    required this.index,
    required this.isLast,
  });

  @override
  State<_JourneyNodeTile> createState() => _JourneyNodeTileState();
}

class _JourneyNodeTileState extends State<_JourneyNodeTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final node = widget.node;

    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => node.pageBuilder()),
            );
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 120),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: node.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: node.colors[1].withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(node.icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              node.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (node.badge != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  node.badge!,
                                  style: const TextStyle(
                                    color: Color(0xFF4A148C),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          node.subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!widget.isLast)
          SizedBox(
            height: 28,
            child: Center(
              child: Container(
                width: 3,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          )
        else
          const SizedBox(height: 8),
      ],
    );
  }
}

/// Reusable celebratory overlay shown after completing any activity.
/// Call from sub-pages via `showActivityReward(context, result)`.
Future<void> showActivityReward(
  BuildContext context,
  ActivityResult result,
) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.55),
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              result.leveledUp ? '🎉' : '✨',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            Text(
              result.leveledUp ? 'Level Up!' : 'Session Complete',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF4A148C),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RewardChip(label: '+${result.xpGained} XP', color: Colors.deepPurple),
                const SizedBox(width: 10),
                _RewardChip(label: '+${result.coinsGained} coins', color: Colors.amber.shade700),
              ],
            ),
            if (result.leveledUp) ...[
              const SizedBox(height: 14),
              Text(
                'You reached Level ${result.newLevel}! New content unlocked.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepPurple.shade400, fontSize: 13),
              ),
            ],
            if (result.streakMilestone) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '🔥 ${result.newStreak}-day streak! Keep it going.',
                  style: const TextStyle(
                      color: Colors.deepOrange, fontWeight: FontWeight.w700, fontSize: 12.5),
                ),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Continue', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    ),
  );
}

class _RewardChip extends StatelessWidget {
  final String label;
  final Color color;
  const _RewardChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }
}