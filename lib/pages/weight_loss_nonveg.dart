import 'package:flutter/material.dart';

class WeightLossNonvegPage extends StatefulWidget {
  const WeightLossNonvegPage({super.key});

  @override
  State<WeightLossNonvegPage> createState() => _WeightLossNonvegPageState();
}

class _WeightLossNonvegPageState extends State<WeightLossNonvegPage> {
  int selectedDay = 0;

  final List<Map<String, dynamic>> mealPlan = [
    {
      "day": "Day 1",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Chicken keema with whole wheat roti and cucumber raita",
          "image": "assets/images/keema.jpg",
          "benefits": "High in protein, supports muscle development and satiety.",
          "calories": "380 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Tandoori chicken breast, brown rice, mixed vegetable salad",
          "image": "assets/images/tandoori.jpg",
          "benefits": "Lean protein, aromatic spices aid digestion and metabolism.",
          "calories": "480 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Shrimp masala with green tea",
          "image": "assets/images/shrimp.jpg",
          "benefits": "Low-calorie protein, iodine for thyroid health.",
          "calories": "140 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Grilled fish fry with lemon, steamed broccoli, brown rice",
          "image": "assets/images/fishfry.jpg",
          "benefits": "Omega-3 rich, supports metabolic health and inflammation control.",
          "calories": "420 kcal"
        },
      ]
    },
    {
      "day": "Day 2",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Chicken and spinach curry with 2 whole wheat chapatis",
          "image": "assets/images/chickenspin.jpg",
          "benefits": "Iron-rich, supports hormone balance and energy.",
          "calories": "350 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Mutton curry (lean), quinoa, steamed vegetables with herbs",
          "image": "assets/images/mutton.jpg",
          "benefits": "High in B vitamins and iron, supports metabolism.",
          "calories": "520 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Turkey kebab with mint chutney",
          "image": "assets/images/kebab.jpg",
          "benefits": "Lean protein, low fat, portable snack.",
          "calories": "160 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Grilled pomfret with garlic, ginger, steamed asparagus",
          "image": "assets/images/pomfret.jpg",
          "benefits": "Light fish, supports healthy cholesterol levels.",
          "calories": "360 kcal"
        },
      ]
    },
    {
      "day": "Day 3",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Chicken sausage breakfast wrap with whole wheat tortilla",
          "image": "assets/images/sausage.jpg",
          "benefits": "Convenient protein source, supports sustained energy.",
          "calories": "340 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Butter chicken (lean), basmati rice, cucumber and tomato salad",
          "image": "assets/images/buttarchicken.jpg",
          "benefits": "Aromatic spices support digestion, protein-rich.",
          "calories": "500 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Grilled chicken with black salt and lemon",
          "image": "assets/images/grilledchicken.jpg",
          "benefits": "Low-calorie, high protein, digestive friendly.",
          "calories": "140 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Baked salmon with herbs, sweet potato, broccoli",
          "image": "assets/images/salmon.jpg",
          "benefits": "Omega-3 rich, supports cardiovascular and mental health.",
          "calories": "450 kcal"
        },
      ]
    },
    {
      "day": "Day 4",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Chicken pepper gravy and 2 whole wheat rotis",
          "image": "assets/images/roti.jpg",
          "benefits": "Complete nutrition, aromatic spices support digestion.",
          "calories": "420 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Crab curry with coconut milk, brown rice, steamed vegetables",
          "image": "assets/images/crab.jpg",
          "benefits": "Selenium-rich, supports thyroid and immune function.",
          "calories": "480 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Tandoori chicken wings with green sauce",
          "image": "assets/images/wings.jpg",
          "benefits": "Protein-rich, satisfying, low-carb snack.",
          "calories": "180 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Pan-seared tuna with wasabi, quinoa, roasted vegetables",
          "image": "assets/images/tuna.jpg",
          "benefits": "Omega-3 dense, supports metabolic health.",
          "calories": "400 kcal"
        },
      ]
    },
    {
      "day": "Day 5",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Dhaba-style chicken curry with 1 whole wheat roti",
          "image": "assets/images/dhaba.jpg",
          "benefits": "Traditional spices aid digestion, protein-rich.",
          "calories": "360 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Grilled fish with mustard oil, rice, mixed vegetable curry",
          "image": "assets/images/mustardfish.jpg",
          "benefits": "Mustard oil supports metabolism and joint health.",
          "calories": "440 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Chicken breast slices with ginger sauce",
          "image": "assets/images/chicken.jpg",
          "benefits": "Iron-rich, supports energy and hormone production.",
          "calories": "150 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Baked chicken breast with herbs, barley, steamed carrots",
          "image": "assets/images/herbchicken.jpg",
          "benefits": "Lean protein, fiber-rich carbs, supports gut health.",
          "calories": "380 kcal"
        },
      ]
    },
    {
      "day": "Day 6",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Prawn curry with coconut, 1 roti, side salad",
          "image": "assets/images/prawn.jpg",
          "benefits": "Low-fat protein, iodine for thyroid function.",
          "calories": "340 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Chicken tikka, brown rice pilaf, cucumber yogurt salad",
          "image": "assets/images/tikka.jpg",
          "benefits": "Marinated chicken is flavorful yet light, supports satiety.",
          "calories": "460 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Fish pakora with mint chutney (baked, not fried)",
          "image": "assets/images/pakora.jpg",
          "benefits": "Crispy texture without excess oil, protein-rich.",
          "calories": "170 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Grilled lamb with mint, farro, roasted root vegetables",
          "image": "assets/images/lambmint.jpg",
          "benefits": "Rich in B vitamins, iron, supports energy metabolism.",
          "calories": "500 kcal"
        },
      ]
    },
    {
      "day": "Day 7",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Chicken dhokla with green chutney",
          "image": "assets/images/dhokla.jpg",
          "benefits": "Steamed preparation, protein-rich, light on digestion.",
          "calories": "280 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Spiced grilled chicken, brown rice, mixed vegetable stir-fry",
          "image": "assets/images/spicedchicken.jpg",
          "benefits": "Aromatic spices enhance metabolism, support weight loss.",
          "calories": "480 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Baked chicken meatballs with tomato sauce",
          "image": "assets/images/meatballs.jpg",
          "benefits": "Lean protein, convenient portion control.",
          "calories": "160 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Baked white fish with lemon thyme, sweet potato fries, broccoli",
          "image": "assets/images/whitefish.jpg",
          "benefits": "Low-calorie protein, supports detoxification.",
          "calories": "420 kcal"
        },
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text(
          "7-Day Weight Loss (Non-Vegetarian)",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Info Banner ───────────────────────────────
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.deepPurple.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: Colors.deepPurple.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "High-protein non-veg meals · PCOS-friendly · Low GI · Anti-inflammatory",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.deepPurple.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── Horizontal Day Selector ───────────────────
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.deepPurple : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected
                            ? Colors.deepPurple
                            : Colors.deepPurple.shade200,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.35),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        mealPlan[index]['day'],
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.deepPurple[800],
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // ── Meal Cards ────────────────────────────────
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
                        // Meal Type Label
                        Text(
                          meal['type'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.deepPurple,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Food Image with fallback
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            meal['image'],
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: 160,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade50,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.restaurant,
                                size: 60,
                                color: Colors.deepPurple.shade200,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Food Name
                        Text(
                          meal['food'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Calories Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "🔥 ${meal['calories']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Divider
                        Divider(color: Colors.deepPurple.shade100, height: 1),

                        const SizedBox(height: 8),

                        // Benefits
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.favorite,
                                color: Colors.deepPurple, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                meal['benefits'],
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
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