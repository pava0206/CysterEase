import 'package:flutter/material.dart';
import 'weight_loss_veg.dart';
import 'weight_loss_egg.dart';
import 'weight_loss_nonveg.dart';

class WeightOptionsPage extends StatelessWidget {
  const WeightOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text(
          "Weight Loss Meal Plan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image + title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/weight_loss.png',
                    height: 160,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.monitor_weight_outlined,
                      size: 80,
                      color: Colors.deepPurple.shade200,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Weight Loss",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Reduce fat naturally with balanced PCOD-friendly meals.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 7-Day label
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.deepPurple.shade200),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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

            // Section title
            const Text(
              "Choose your diet type",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 14),

            // Diet buttons
            _dietButton(
              context,
              label: "Vegetarian",
              icon: Icons.eco,
              subtitle: "Plant-based meals rich in iron & fiber",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WeightLossVegPage()),
              ),
            ),
            const SizedBox(height: 12),
            _dietButton(
              context,
              label: "Eggetarian",
              icon: Icons.egg,
              subtitle: "Egg-powered protein with Tamil superfoods",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WeightLossEggPage()),
              ),
            ),
            const SizedBox(height: 12),
            _dietButton(
              context,
              label: "Non-Vegetarian",
              icon: Icons.restaurant,
              subtitle: "High-protein chicken, fish & seafood meals",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WeightLossNonvegPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dietButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.deepPurple.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.deepPurple, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.deepPurple.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: Colors.deepPurple.shade300),
          ],
        ),
      ),
    );
  }
}