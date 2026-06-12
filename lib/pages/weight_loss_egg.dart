import 'package:flutter/material.dart';

class WeightLossEggPage extends StatefulWidget {
  const WeightLossEggPage({super.key});

  @override
  State<WeightLossEggPage> createState() => _WeightLossEggPageState();
}

class _WeightLossEggPageState extends State<WeightLossEggPage> {
  int selectedDay = 0;

  final List<Map<String, dynamic>> mealPlan = [
    {
      "day": "Day 1",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "2 boiled eggs with whole wheat toast and avocado",
          "image": "assets/images/boiledeggs.jpg",
          "benefits": "High in protein and choline for hormonal balance.",
          "calories": "280 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Grilled chicken breast, brown rice, steamed broccoli",
          "image": "assets/images/grilledchicken.jpg",
          "benefits": "Lean protein, low carb, aids weight loss.",
          "calories": "450 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Egg white omelette with mushrooms",
          "image": "assets/images/eggwhite.jpg",
          "benefits": "Low-calorie protein source, supports muscle maintenance.",
          "calories": "120 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Baked salmon with lemon, mixed vegetables, olive oil",
          "image": "assets/images/salmon.jpg",
          "benefits": "Rich in omega-3, supports metabolism and heart health.",
          "calories": "350 kcal"
        },
      ]
    },
    {
      "day": "Day 2",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Egg scramble with cheese, spinach, and whole grain bread",
          "image": "assets/images/eggscramble.jpg",
          "benefits": "High protein, iron-rich, supports hormonal health.",
          "calories": "320 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Turkey meatballs, quinoa, cucumber salad with olive oil dressing",
          "image": "assets/images/turkey.jpg",
          "benefits": "Lean protein, complete amino acids, aids satiety.",
          "calories": "480 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Hard-boiled eggs with sea salt and pepper",
          "image": "assets/images/hardboiled.jpg",
          "benefits": "Portable protein, supports stable blood sugar.",
          "calories": "155 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Grilled cod with roasted sweet potato and asparagus",
          "image": "assets/images/cod.jpg",
          "benefits": "Lean protein, low-GI carbs, supports digestion.",
          "calories": "380 kcal"
        },
      ]
    },
    {
      "day": "Day 3",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Vegetable frittata with 3 eggs and bell peppers",
          "image": "assets/images/frittata.jpg",
          "benefits": "Loaded with nutrients, supports sustained energy.",
          "calories": "240 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Shrimp stir-fry with brown rice and mixed vegetables",
          "image": "assets/images/shrimp.jpg",
          "benefits": "Low-calorie protein, iodine for thyroid health.",
          "calories": "420 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Egg white pudding with almonds",
          "image": "assets/images/pudding.jpg",
          "benefits": "High protein, low-fat, satisfying.",
          "calories": "140 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Grilled chicken thighs with cauliflower rice and garlic sauce",
          "image": "assets/images/chickthighs.jpg",
          "benefits": "Rich in B vitamins, supports energy metabolism.",
          "calories": "360 kcal"
        },
      ]
    },
    {
      "day": "Day 4",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Egg and cheese breakfast sandwich on whole wheat",
          "image": "assets/images/eggsandwich.jpg",
          "benefits": "Balanced nutrition, sustained energy release.",
          "calories": "300 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Baked chicken breast with wild rice and steamed green beans",
          "image": "assets/images/wildrice.jpg",
          "benefits": "High protein, fiber-rich, promotes fullness.",
          "calories": "460 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Boiled eggs with celery sticks and hummus",
          "image": "assets/images/eggsnack.jpg",
          "benefits": "Portable, nutrient-dense, low-calorie.",
          "calories": "180 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Pan-seared tuna with roasted vegetables and olive oil",
          "image": "assets/images/tuna.jpg",
          "benefits": "Omega-3 rich, supports metabolic health.",
          "calories": "340 kcal"
        },
      ]
    },
    {
      "day": "Day 5",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "3-egg omelette with mushrooms, onions, and tomatoes",
          "image": "assets/images/omelette.jpg",
          "benefits": "High protein, loaded with antioxidants.",
          "calories": "260 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Grilled turkey breast, brown rice, steamed broccoli and carrots",
          "image": "assets/images/turkeybreast.jpg",
          "benefits": "Lean protein, low fat, supports muscle recovery.",
          "calories": "440 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Egg protein shake with Greek yogurt and berries",
          "image": "assets/images/proteinshakeegg.jpg",
          "benefits": "High protein, probiotic-rich, low sugar.",
          "calories": "160 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Baked salmon with quinoa and roasted Brussels sprouts",
          "image": "assets/images/salmonquinoa.jpg",
          "benefits": "Complete protein, omega-3, supports hormonal balance.",
          "calories": "420 kcal"
        },
      ]
    },
    {
      "day": "Day 6",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Boiled eggs with whole wheat toast, butter, and herbs",
          "image": "assets/images/toasteggs.jpg",
          "benefits": "Simple, nutrient-dense, supports steady energy.",
          "calories": "280 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Grilled chicken breast, barley, steamed vegetables with lemon",
          "image": "assets/images/barleyrice.jpg",
          "benefits": "Complete nutrition, fiber-rich, aids digestion.",
          "calories": "450 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Scrambled eggs with spinach and feta cheese",
          "image": "assets/images/spinacheggs.jpg",
          "benefits": "Iron-rich, calcium-rich, supports bone health.",
          "calories": "200 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Baked white fish with sweet potato and steamed asparagus",
          "image": "assets/images/whitefish.jpg",
          "benefits": "Low-calorie protein, essential minerals, supports detox.",
          "calories": "360 kcal"
        },
      ]
    },
    {
      "day": "Day 7",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Egg white scramble with bell peppers and low-fat cheese",
          "image": "assets/images/eggwhitebellpepper.jpg",
          "benefits": "Low calorie, high protein, aids weight loss.",
          "calories": "180 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Grilled chicken with farro, roasted root vegetables",
          "image": "assets/images/farro.jpg",
          "benefits": "Protein-rich, complex carbs, sustains energy.",
          "calories": "480 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Boiled eggs with herbs and sea salt",
          "image": "assets/images/herbseggs.jpg",
          "benefits": "Antioxidant-rich, supports metabolism.",
          "calories": "155 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Grilled lamb with mint, quinoa, and roasted vegetables",
          "image": "assets/images/lamb.jpg",
          "benefits": "Rich in iron and B vitamins, supports energy.",
          "calories": "420 kcal"
        },
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: const Text("7-Day Weight Loss (Egg & Chicken)",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.amber[700],
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // 🔹 Horizontal Scrollable Day Selector
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: mealPlan.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedDay;
                return GestureDetector(
                  onTap: () => setState(() => selectedDay = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.amber[700] : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected
                            ? Colors.amber[700]!
                            : Colors.amber.shade200,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        mealPlan[index]['day'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.amber[800],
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // 🍽️ Meal Cards for Selected Day
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: mealPlan[selectedDay]['meals'].length,
              itemBuilder: (context, index) {
                final meal = mealPlan[selectedDay]['meals'][index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(meal['type'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.amber[700])),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            meal['image'],
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(meal['food'],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text(meal['benefits'],
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 14)),
                        const SizedBox(height: 6),
                        Text("Calories: ${meal['calories']}",
                            style: TextStyle(
                                color: Colors.amber[700],
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
