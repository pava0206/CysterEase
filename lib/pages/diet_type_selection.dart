import 'package:flutter/material.dart';

import '../models/diet_plan_filters.dart';
import 'meal_plan_screen.dart';

class DietTypeSelectionPage extends StatelessWidget {
  final Goal selectedGoal;
  final Lifestyle selectedLifestyle;

  const DietTypeSelectionPage({
    super.key,
    required this.selectedGoal,
    required this.selectedLifestyle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Food Preference"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: DietType.values.length,
        itemBuilder: (context, index) {
          final dietType = DietType.values[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MealPlanScreen(
                      goal: selectedGoal,
                      lifestyle: selectedLifestyle,
                      dietType: dietType,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.deepPurple.shade50,
                      child: Icon(
                        dietType.icon,
                        color: Colors.deepPurple,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            dietType.label,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            dietType.subtitle,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.deepPurple,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}