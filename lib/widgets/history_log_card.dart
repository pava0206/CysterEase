import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryLogCard extends StatelessWidget {
  final DateTime startDate;
  final String flow;
  final String mood;

  const HistoryLogCard({
    super.key,
    required this.startDate,
    required this.flow,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color:
                  Colors.deepPurple.shade50,
              borderRadius:
                  BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                DateFormat('dd')
                    .format(startDate),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat(
                    'MMMM yyyy',
                  ).format(startDate),
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "$flow • $mood",
                  style: TextStyle(
                    color:
                        Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}