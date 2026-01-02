import 'package:flutter/material.dart';

// ✅ Import all the target pages
import 'affirmations_page.dart';
import 'meditation_page.dart';
import 'journal_page.dart';
import 'read_a_tip.dart'; // ✅ Make sure this file exists as lib/read_a_tip.dart

class StressManagementPage extends StatefulWidget {
  const StressManagementPage({super.key});

  @override
  State<StressManagementPage> createState() => _StressManagementPageState();
}

class _StressManagementPageState extends State<StressManagementPage> {
  final PageController _controller = PageController(viewportFraction: 0.78);
  double currentPage = 0.0;

  final List<_StressTile> tiles = [];

  @override
  void initState() {
    super.initState();

    tiles.addAll([
      _StressTile(
        title: 'Positive Affirmations',
        subtitle: 'Rewire your thoughts 🌸',
        imageAsset: 'assets/images/affirm.png',
        onTap: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AffirmationsPage()),
          );
        },
      ),
      _StressTile(
        title: '2-Min Meditation',
        subtitle: 'Find your calm 🧘‍♀️',
        imageAsset: 'assets/images/meditate.png',
        onTap: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MeditationPage()),
          );
        },
      ),
      _StressTile(
        title: 'Journal Prompt',
        subtitle: 'Reflect & release ✍️',
        imageAsset: 'assets/images/journal.png',
        onTap: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const JournalPage()),
          );
        },
      ),
      _StressTile(
        title: 'Read a Tip',
        subtitle: 'Daily stress relief 💡',
        imageAsset: 'assets/images/tip.png',
        onTap: (context) {
          // ✅ Navigation fixed to match ReadATipPage class
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReadATipPage()),
          );
        },
      ),
    ]);

    _controller.addListener(() {
      setState(() {
        currentPage = _controller.page ?? 0.0;
      });
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
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Stress Management'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Choose Your Calm Path",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 🌸 Animated PageView
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: tiles.length,
                itemBuilder: (context, index) {
                  final scale =
                      (1 - ((currentPage - index).abs() * 0.15)).clamp(0.85, 1.0);
                  final tile = tiles[index];

                  return Transform.scale(
                    scale: scale,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      margin:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.deepPurple.shade100,
                          width: 1.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Image.asset(
                            tile.imageAsset,
                            height: 300,
                            width: 300,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            tile.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tile.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black.withOpacity(1.0),
                            ),
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 34, vertical: 11),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 3,
                            ),
                            onPressed: () => tile.onTap(context),
                            child: const Text(
                              "Select",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StressTile {
  final String title;
  final String subtitle;
  final String imageAsset;
  final Function(BuildContext) onTap;

  _StressTile({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.onTap,
  });
}
