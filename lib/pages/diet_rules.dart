import 'package:flutter/material.dart';
import 'package:cysterease/pages/weight_options.dart'; // 👈 Add this import

class DietRulesPage extends StatelessWidget {
  const DietRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> rules = [
      {
        'title': 'Medical Consultation',
        'desc':
            'Before following any kind of diet, if you have any food intolerances or allergies, please consult your doctor to confirm whether you can safely proceed.'
      },
      {
        'title': 'Recommended Health Tests',
        'desc':
            'It is advisable to take the following tests before starting the diet:\n• Complete Blood Count (CBC)\n• Free Thyroid Test\n• Lipid Profile\n• Liver Function Test\n• HbA1C\n• Blood Urea, Creatinine, and Uric Acid\n• Blood Pressure\n• Urine Routine\n• USG Abdomen & Pelvis (for females)'
      },
      {
        'title': 'Age Requirement',
        'desc':
            'These diet plans are recommended only for users above 18 years of age.'
      },
      {
        'title': 'For Diabetic Users',
        'desc':
            'Diabetic patients are advised to follow the diet under a doctor’s supervision.'
      },
      {
        'title': 'Meal Frequency',
        'desc':
            'Maintain three proper meals per day — avoid frequent snacking.'
      },
      {
        'title': 'Meal Order',
        'desc':
            'Eat in the following order:\nProtein + Natural Fat → Vegetables (Fiber) → Rice/Chapathi/Roti (small portion).'
      },
      {
        'title': 'Dinner Timing',
        'desc':
            'Have your dinner at least two hours before sleep.'
      },
      {
        'title': 'Foods to Avoid',
        'desc':
            'Avoid sugary drinks and snacks, refined carbohydrates, processed meats, and trans fats.'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text(
          'Diet Guidelines',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 3,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: rules.length,
              itemBuilder: (context, index) {
                final rule = rules[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      rule['title'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.deepPurple,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        rule['desc'] ?? '',
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Continue Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // Navigate to Weight Options Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WeightOptionsPage(),
                  ),
                );
              },
              child: const Text(
                "Continue",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
