import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final String selectedMood;
  final Function(String) onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  static const moods = [
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '😔', 'label': 'Sad'},
    {'emoji': '😡', 'label': 'Irritated'},
    {'emoji': '😴', 'label': 'Tired'},
    {'emoji': '😌', 'label': 'Calm'},
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: moods.map((mood) {
        final isSelected =
            selectedMood == mood['label'];

        return GestureDetector(
          onTap: () {
            onMoodSelected(
                mood['label']!);
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.deepPurple
                  : Colors.white,
              borderRadius:
                  BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mood['emoji']!,
                  style:
                      const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 6),
                Text(
                  mood['label']!,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}