import 'package:flutter/material.dart';

class DailySummaryCard extends StatelessWidget {
  final int totalCalories;
  final String waterReminder;
  final String dailyTip;

  const DailySummaryCard({
    super.key,
    required this.totalCalories,
    required this.waterReminder,
    required this.dailyTip,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                ),
                const SizedBox(width: 10),
                Text(
                  "$totalCalories kcal",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.water_drop,
                  color: Colors.blue,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    waterReminder,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.amber,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    dailyTip,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}