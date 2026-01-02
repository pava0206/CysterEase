import 'package:flutter/material.dart';
import 'package:cysterease/pages/welcome_page.dart';
import 'package:cysterease/pages/sleep_tracker.dart';
import 'package:cysterease/pages/stress_management.dart';
import 'package:cysterease/pages/diet_rules.dart';
import 'package:cysterease/pages/workout_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showMoveButton = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        // Hide button near the end
        setState(() => _showMoveButton = false);
      } else {
        // Show button again if user scrolls back
        setState(() => _showMoveButton = true);
      }
    });
  }

  void _scrollNext() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset + 200,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text('Welcome to CysterEase'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your Daily Tools",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16),

              // 🔹 Sliding Cards Section
              SizedBox(
                height: 220,
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    _DashboardCard(
                      imageAsset: 'assets/images/diet.png',
                      title: 'Diet Planner',
                      subtitle: 'Personalized PCOD meal plans',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DietRulesPage()),
                        );
                      },
                    ),
                    _DashboardCard(
                      imageAsset: 'assets/images/stress.png',
                      title: 'Stress Tools',
                      subtitle: 'Calm your mind & body',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const StressManagementPage()),
                        );
                      },
                    ),
                    _DashboardCard(
                      imageAsset: 'assets/images/workout.png',
                      title: 'Workout Planner',
                      subtitle: 'Stay active with PCOD-safe moves',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WorkoutDetailPage()),
                        );
                      },
                    ),
                    _DashboardCard(
                      imageAsset: 'assets/images/sleep.png',
                      title: 'Sleep Tracker',
                      subtitle: 'Build better sleep habits',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SleepTrackerPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 Move Button (scrolls the list)
              // 🔹 Move Button (scrolls the list)
if (_showMoveButton)
  Align(
    alignment: Alignment.centerRight,
    child: ElevatedButton.icon(
      onPressed: _scrollNext,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      icon: const Icon(
        Icons.arrow_forward_rounded,
        color: Colors.white,
        size: 22, // Bold and clear arrow
      ),
      label: const Text(
        "Move",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ),
  ),


              const SizedBox(height: 20),

              // 🔹 Articles Section
              const Text(
                "Articles",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 12),
              _ArticleCard(
                title: 'PCOS and Sleep',
                description:
                    'Understand the link between sleep and PCOS management.',
                url: 'https://www.askpcos.org/articles/pcos-and-sleep/',
              ),
              _ArticleCard(
                title: 'Best PCOS Diet Tips',
                description:
                    'Explore healthy eating for better PCOS outcomes.',
                url:
                    'https://www.hopkinsmedicine.org/health/wellness-and-prevention/pcos-diet',
              ),
              _ArticleCard(
                title: 'PCOS and Insomnia: Research',
                description: 'Scientific review: sleep disorders in PCOS.',
                url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC10032018/',
              ),
              _ArticleCard(
                title: 'Exercise for PCOS',
                description: 'Workouts proven to help with PCOS and fertility.',
                url:
                    'https://www.healthline.com/health/womens-health/exercise-for-pcos#fertility',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.deepPurple.shade100,
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Image.asset(
              imageAsset,
              height: 110,
              width: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.deepPurple.withOpacity(1.00),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final String title;
  final String description;
  final String url;

  const _ArticleCard({
    required this.title,
    required this.description,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 13),
        ),
        trailing: Icon(Icons.open_in_new, color: Colors.deepPurple[300]),
        onTap: () async {
          final Uri uri = Uri.parse(url);
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open article link')),
            );
          }
        },
      ),
    );
  }
}

