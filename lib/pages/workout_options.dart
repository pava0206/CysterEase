import 'package:flutter/material.dart';
import 'cardio.dart';
import 'hiit.dart';
import 'yoga.dart';
import 'strength.dart';

class WorkoutOptionsPage extends StatefulWidget {
  const WorkoutOptionsPage({super.key});

  @override
  State<WorkoutOptionsPage> createState() => _WorkoutOptionsPageState();
}

class _WorkoutOptionsPageState extends State<WorkoutOptionsPage> {
  final PageController _controller = PageController(viewportFraction: 0.85);

  final List<Map<String, String>> slides = [
    {
      'title': 'Steady-state cardio',
      'desc':
          'Helps regulate hormones, improve insulin sensitivity, and support healthy weight management.',
      'image': 'assets/images/cardio.png',
    },
    {
      'title': 'HIIT workouts',
      'desc':
          'High-intensity intervals boost metabolism, improve insulin sensitivity, and promote faster fat loss.',
      'image': 'assets/images/hiit.png',
    },
    {
      'title': 'Mind-body exercises',
      'desc':
          'Reduces stress, balances hormones, and enhances emotional well-being through calm movement.',
      'image': 'assets/images/yoga.png',
    },
    {
      'title': 'Strength training',
      'desc':
          'Builds lean muscle, increases metabolism, and helps stabilize insulin levels effectively.',
      'image': 'assets/images/strength.png',
    },
  ];

  int _currentPage = 0;

  void _navigateToWorkout(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CardioPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HiitPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const YogaPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StrengthPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text(
          "Workout Options",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 3,
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: slides.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final slide = slides[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: _currentPage == index ? 10 : 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Image.asset(
                            slide['image']!,
                            height: 210,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 35),
                          Text(
                            slide['title']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            slide['desc']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _navigateToWorkout(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: const Text(
                                "Start",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              slides.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 14 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.deepPurple
                      : Colors.deepPurple.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
