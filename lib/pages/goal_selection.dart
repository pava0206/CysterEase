import 'package:flutter/material.dart';

import '../models/diet_plan_filters.dart';
import 'lifestyle_selection.dart';

class GoalSelectionPage extends StatelessWidget {
  const GoalSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your Goal"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: Goal.values.length,
        itemBuilder: (context, index) {
          final goal = Goal.values[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: goal.isAvailable
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LifestyleSelectionPage(
                            selectedGoal: goal,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.deepPurple.shade50,
                      child: Icon(
                        goal.icon,
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
                            goal.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            goal.subtitle,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (!goal.isAvailable)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Coming Soon",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.orange,
                          ),
                        ),
                      )
                    else
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