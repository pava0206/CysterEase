// lib/pages/mood_checkin.dart
//
// Two responsibilities living in one file because they're tightly related:
//  1) MoodPickerSheet — a quick bottom-sheet emoji picker, shown BEFORE and
//     AFTER an activity. Returns an int 1-5.
//  2) MoodTrendPage — a full page showing mood history as a simple line
//     chart (no external chart package — hand-drawn with CustomPainter so
//     we don't add a new dependency to your pubspec).

import 'package:flutter/material.dart';
import 'stress_service.dart';

const List<String> kMoodEmojis = ['😣', '😕', '😐', '🙂', '😄'];
const List<String> kMoodLabels = [
  'Awful',
  'Low',
  'Okay',
  'Good',
  'Great',
];

/// Shows a modal bottom sheet asking "how are you feeling?" and resolves
/// with the chosen mood (1-5), or null if dismissed without choosing.
Future<int?> showMoodPicker(
  BuildContext context, {
  required String prompt,
}) {
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder: (context) => _MoodPickerSheet(prompt: prompt),
  );
}

class _MoodPickerSheet extends StatelessWidget {
  final String prompt;
  const _MoodPickerSheet({required this.prompt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            prompt,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4A148C),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (i) {
              final mood = i + 1;
              return GestureDetector(
                onTap: () => Navigator.of(context).pop(mood),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Text(kMoodEmojis[i],
                          style: const TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      kMoodLabels[i],
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.deepPurple.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Full-page mood trend view, reachable from the hub. Shows recent
/// mood-shift history so users can SEE that this section helps them —
/// which is itself a retention mechanic.
class MoodTrendPage extends StatefulWidget {
  const MoodTrendPage({super.key});

  @override
  State<MoodTrendPage> createState() => _MoodTrendPageState();
}

class _MoodTrendPageState extends State<MoodTrendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Mood Journey'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      backgroundColor: Colors.deepPurple[50],
      body: StreamBuilder<List<MoodLogEntry>>(
        stream: StressService.instance.watchRecentMoodLogs(limit: 14),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final logs = (snapshot.data ?? []).reversed.toList(); // chronological

          if (logs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🌱', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 16),
                    Text(
                      'Complete a few activities and your mood trend will show up here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.deepPurple.shade400,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final avgShift = logs.map((l) => l.shift).reduce((a, b) => a + b) /
              logs.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Text(avgShift >= 0 ? '📈' : '📉',
                          style: const TextStyle(fontSize: 32)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              avgShift > 0.3
                                  ? 'On average, this space is lifting your mood'
                                  : 'Keep checking in — patterns take time',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Avg shift: ${avgShift >= 0 ? '+' : ''}${avgShift.toStringAsFixed(1)}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'LAST ${logs.length} SESSIONS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    color: Colors.deepPurple.shade400,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  height: 220,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _MoodChartPainter(logs: logs),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'RECENT CHECK-INS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    color: Colors.deepPurple.shade400,
                  ),
                ),
                const SizedBox(height: 12),
                ...logs.reversed.map((log) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Text(kMoodEmojis[log.moodBefore - 1],
                              style: const TextStyle(fontSize: 22)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.arrow_forward_rounded,
                                size: 16, color: Colors.deepPurple),
                          ),
                          Text(kMoodEmojis[log.moodAfter - 1],
                              style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              log.activity,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.deepPurple.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (log.shift > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('+${log.shift}',
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700)),
                            ),
                        ],
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MoodChartPainter extends CustomPainter {
  final List<MoodLogEntry> logs;
  _MoodChartPainter({required this.logs});

  @override
  void paint(Canvas canvas, Size size) {
    if (logs.isEmpty) return;
    final padding = 12.0;
    final w = size.width - padding * 2;
    final h = size.height - padding * 2;
    final n = logs.length;

    double xFor(int i) => padding + (n == 1 ? w / 2 : w * i / (n - 1));
    double yFor(int mood) => padding + h - (h * (mood - 1) / 4);

    // Gridlines
    final gridPaint = Paint()
      ..color = Colors.deepPurple.withOpacity(0.06)
      ..strokeWidth = 1;
    for (int m = 1; m <= 5; m++) {
      final y = yFor(m);
      canvas.drawLine(Offset(padding, y), Offset(size.width - padding, y), gridPaint);
    }

    // "After" line (the story we want to tell: mood after activities)
    final afterPath = Path();
    final beforePath = Path();
    for (int i = 0; i < n; i++) {
      final ax = xFor(i);
      final ay = yFor(logs[i].moodAfter);
      final by = yFor(logs[i].moodBefore);
      if (i == 0) {
        afterPath.moveTo(ax, ay);
        beforePath.moveTo(ax, by);
      } else {
        afterPath.lineTo(ax, ay);
        beforePath.lineTo(ax, by);
      }
    }

    canvas.drawPath(
      beforePath,
      Paint()
        ..color = Colors.deepPurple.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawPath(
      afterPath,
      Paint()
        ..color = const Color(0xFF6A1B9A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Dots on the "after" line
    for (int i = 0; i < n; i++) {
      canvas.drawCircle(
        Offset(xFor(i), yFor(logs[i].moodAfter)),
        4,
        Paint()..color = const Color(0xFF6A1B9A),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MoodChartPainter oldDelegate) => true;
}