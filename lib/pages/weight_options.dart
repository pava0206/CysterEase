import 'package:flutter/material.dart';
import 'weight_loss_veg.dart'; // ✅ Import vegetarian meal plan page

class WeightOptionsPage extends StatefulWidget {
  const WeightOptionsPage({super.key});

  @override
  State<WeightOptionsPage> createState() => _WeightOptionsPageState();
}

class _WeightOptionsPageState extends State<WeightOptionsPage> {
  final PageController _controller = PageController(viewportFraction: 0.85);

  final List<Map<String, String>> goals = [
    {
      'title': 'Weight Loss',
      'desc': 'Reduce fat naturally with balanced PCOD-friendly meals.',
      'image': 'assets/images/weight_loss.png',
    },
    {
      'title': 'Weight Gain',
      'desc': 'Gain healthy weight with nutrient-rich, hormone-balanced foods.',
      'image': 'assets/images/weight_gain.png',
    },
    {
      'title': 'Fertility Support',
      'desc': 'Enhance fertility with antioxidant and hormone-balancing diet.',
      'image': 'assets/images/fertility_support.png',
    },
  ];

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text(
          "Select Your Goal",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 3,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: goals.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final goal = goals[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: _currentPage == index ? 10 : 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Image.asset(
                          goal['image']!,
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          goal['title']!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            goal['desc']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // 🌟 7-Day Meal Plan Box
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border:
                                Border.all(color: Colors.deepPurple.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.calendar_month, color: Colors.deepPurple),
                              SizedBox(width: 10),
                              Text(
                                "7-Day Diet Meal Plan",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 🍽️ Diet Type Buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              _dietButton(context, "Vegetarian", Icons.eco,
                                  goal['title']!),
                              const SizedBox(height: 12),
                              _dietButton(context, "Eggetarian", Icons.egg,
                                  goal['title']!),
                              const SizedBox(height: 12),
                              _dietButton(context, "Non-Vegetarian",
                                  Icons.restaurant, goal['title']!),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔹 Page Indicator
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              goals.length,
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

  // 🌿 Modified diet button to handle navigation properly
  Widget _dietButton(
      BuildContext context, String label, IconData icon, String goalTitle) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // ✅ Only Weight Loss + Vegetarian navigates to next page
          if (goalTitle == "Weight Loss" && label == "Vegetarian") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WeightLossVegPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("$label plan for $goalTitle is coming soon! 🥗"),
                backgroundColor: Colors.deepPurple,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepPurple,
          elevation: 3,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.deepPurple.shade100),
          ),
        ),
        icon: Icon(icon, size: 22),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
