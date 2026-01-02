import 'package:flutter/material.dart';
import 'workout_options.dart';

class WorkoutDetailPage extends StatefulWidget {
  const WorkoutDetailPage({super.key});

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  final PageController _controller = PageController(viewportFraction: 0.85);

  final List<Map<String, String>> slides = [
    {
      'title': 'Insulin Resistance',
      'desc':
          'Women with PCOS often face insulin resistance, making it harder for the body to use sugar for energy. Regular exercise helps manage it effectively.',
      'image': 'assets/images/workout1.png',
    },
    {
      'title': 'Move to Improve',
      'desc':
          'Lack of physical activity can worsen insulin resistance. Even daily walks or stretches can help balance your hormones and improve energy.',
      'image': 'assets/images/workout2.png',
    },
    {
      'title': 'Exercise for All',
      'desc':
          'You don’t need to lose weight to see benefits. Regular movement supports your mood, metabolism, and overall PCOS wellness.',
      'image': 'assets/images/workout3.png',
    },
  ];

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text(
          "Workout Planner",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 3,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 25),

              // 🔹 PageView for slides
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

                              // ✅ "Get Started" button only on last slide
                              if (index == slides.length - 1)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const WorkoutOptionsPage(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                    ),
                                    child: const Text(
                                      "Get Started",
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

              // 🔸 Dots Indicator
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
              const SizedBox(height: 70), // 👇 leave space for skip button
            ],
          ),

          // ✅ Skip button (bottom-left corner, not on last slide)
          if (_currentPage != slides.length - 1)
            Positioned(
              bottom: 25,
              left: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkoutOptionsPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
