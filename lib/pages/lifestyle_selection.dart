import 'package:flutter/material.dart';

import '../models/diet_plan_filters.dart';
import 'diet_type_selection.dart';

class LifestyleSelectionPage extends StatelessWidget {
  final Goal selectedGoal;

  const LifestyleSelectionPage({
    super.key,
    required this.selectedGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your Lifestyle"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: Lifestyle.values.length,
        itemBuilder: (context, index) {
          final lifestyle = Lifestyle.values[index];

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
                    builder: (_) => DietTypeSelectionPage(
                      selectedGoal: selectedGoal,
                      selectedLifestyle: lifestyle,
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
                        lifestyle.icon,
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
                            lifestyle.label,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lifestyle.subtitle,
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