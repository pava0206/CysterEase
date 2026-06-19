import 'package:flutter/material.dart';

import '../models/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meal.mealType.toUpperCase(),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              meal.mealName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: meal.ingredients
                  .map(
                    (ingredient) => Chip(
                      label: Text(ingredient),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.local_fire_department,
                    color: Colors.orange),
                const SizedBox(width: 6),
                Text("${meal.calories} kcal"),
                const Spacer(),
                const Icon(Icons.schedule,
                    color: Colors.blueGrey),
                const SizedBox(width: 6),
                Text("${meal.prepTimeMinutes} min"),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.bar_chart,
                    color: Colors.green),
                const SizedBox(width: 6),
                Text(meal.difficulty),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              meal.benefit,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),

            if (meal.affordableSwaps.isNotEmpty) ...[
              const Divider(height: 24),
              const Text(
                "Affordable Swaps",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),
              ...meal.affordableSwaps.map(
                (swap) => Text(
                  "• ${swap.original} → ${swap.swap}",
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}