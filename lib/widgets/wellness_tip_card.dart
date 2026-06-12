import 'package:flutter/material.dart';

class WellnessTipCard extends StatelessWidget {
  final String tip;

  const WellnessTipCard({
    super.key,
    required this.tip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF8B5CF6),
            Color(0xFF6D28D9),
          ],
        ),
        borderRadius:
            BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Text(
            "🌿",
            style: TextStyle(fontSize: 34),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}