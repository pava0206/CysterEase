import 'package:flutter/material.dart';

class WeightLossVegPage extends StatefulWidget {
  const WeightLossVegPage({super.key});

  @override
  State<WeightLossVegPage> createState() => _WeightLossVegPageState();
}

class _WeightLossVegPageState extends State<WeightLossVegPage> {
  int selectedDay = 0;

  final List<Map<String, dynamic>> mealPlan = [
    {
      "day": "Day 1",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Lentil and rice pancake (Adai dosa)",
          "image": "assets/images/adai.jpg",
          "benefits": "Manages weight, blood sugar, and inflammation.",
          "calories": "114–203 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Boiled peanut sundal, radish sambar, carrot poriyal with rice",
          "image": "assets/images/sambhar.jpg",
          "benefits": "Low-GI, high fiber and protein ingredients.",
          "calories": "450–700 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Green tea + handful of almonds",
          "image": "assets/images/greentea.jpg",
          "benefits": "Reduces insulin resistance and inflammation.",
          "calories": "170 kcal (green tea 0 kcal)"
        },
        {
          "type": "Dinner 🍛",
          "food": "Cucumber Raita with coconut flakes",
          "image": "assets/images/cucumber.jpeg",
          "benefits": "Manages blood sugar, reduces inflammation.",
          "calories": "147 kcal"
        },
      ]
    },
    {
      "day": "Day 2",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Pesarattu dosas, cheese slices & peanut chutney",
          "image": "assets/images/pesarattu.jpg",
          "benefits": "High in protein and healthy fats for hormone balance.",
          "calories": "987 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Soybean sundal, banana flower kootu, cauliflower varuval, rice",
          "image": "assets/images/soyabean.jpg",
          "benefits": "Rich in plant protein and fiber, regulates hormones.",
          "calories": "530 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Roasted Makhana",
          "image": "assets/images/makhana.jpg",
          "benefits": "Rich in protein and antioxidants.",
          "calories": "120 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Chia Seeds with Curd & Coconut Flakes",
          "image": "assets/images/chiaseeds.webp",
          "benefits": "Boosts digestion and provides healthy fats.",
          "calories": "320 kcal"
        },
      ]
    },
    {
      "day": "Day 3",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Paneer Bhurji with vegetables",
          "image": "assets/images/pannerbhurji.jpg",
          "benefits": "High in protein and nutrients.",
          "calories": "250 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Cowpea (karamani) sundal, avarai sambar, beans poriyal, rice",
          "image": "assets/images/karamani.webp",
          "benefits": "Rich in fiber and protein.",
          "calories": "420 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Coconut water + roasted chana",
          "image": "assets/images/chana.webp",
          "benefits": "Provides quick energy and electrolytes.",
          "calories": "160 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Fenugreek & bottle gourd curry with roasted gram",
          "image": "assets/images/bottle.jpg",
          "benefits": "Supports digestion and balances blood sugar.",
          "calories": "250 kcal"
        },
      ]
    },
    {
      "day": "Day 4",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Tofu burji with boiled chickpeas",
          "image": "assets/images/tofu.jpg",
          "benefits": "High in protein and fiber, helps balance hormones.",
          "calories": "280 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Rajma sundal, banana stem sambar, beans poriyal, rice",
          "image": "assets/images/rajma.jpeg",
          "benefits": "Rich in fiber and protein.",
          "calories": "350 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Green tea with roasted chana",
          "image": "assets/images/green.webp",
          "benefits": "Improves insulin sensitivity and reduces inflammation.",
          "calories": "269 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Roasted seeds mix, nuts, curd, and coconut flakes",
          "image": "assets/images/seeds.jpeg",
          "benefits": "Rich in healthy fats and protein.",
          "calories": "550 kcal"
        },
      ]
    },
    {
      "day": "Day 5",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "2 low-carb chapati (almond/coconut flour), curd, green peas masala",
          "image": "assets/images/almond.jpg",
          "benefits": "High protein, low carb, good for digestion",
          "calories": "500 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "100 g chickpeas sundal, 200 g keerai kootu, 100 g cabbage poriyal, 100 g rice",
          "image": "assets/images/keerai.jpg",
          "benefits": "High in fiber and protein, supports digestion",
          "calories": "520 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Plain Greek yogurt,topped with fruit for sweetness",
          "image": "assets/images/yogurt.jpg",
          "benefits": "High protein, probiotic-rich, boosts gut health",
          "calories": "180 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Paneer tawa fry, curd, 2 unripe guavas",
          "image": "assets/images/tawapanner.jpg",
          "benefits": "Protein-rich, improves digestion",
          "calories": "460 kcal"
        },
      ]
    },
    {
      "day": "Day 6",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "2 low-carb vendhaya keerai chapatis (almond/coconut flour), curd, peanut chutney (100 g)",
          "image": "assets/images/keerachapathi.jpg",
          "benefits": "High protein, low carb, boosts metabolism",
          "calories": "550 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "100 g pacha payaru sprouts sundal, 150 g chow chow (sambar/kootu), 100 g capsicum poriyal, 100 g rice",
          "image": "assets/images/pachapayiru.webp",
          "benefits": "Protein- and fiber-rich, improves digestion and immunity.",
          "calories": "520 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Apple with peanut butter",
          "image": "assets/images/apple.jpeg",
          "benefits": "High in fiber and healthy fats",
          "calories": "250 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Coconut flour upma with veggies, mustard, curry leaves, and 1 cup curd",
          "image": "assets/images/upma.jpeg",
          "benefits": "Fiber-rich, gut-friendly, supports digestion",
          "calories": "520 kcal"
        },
      ]
    },
    {
      "day": "Day 7",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food": "Paneer dosa with 100 g chickpeas curry",
          "image": "assets/images/pannerdosa.webp",
          "benefits": "High protein, supports muscle strength",
          "calories": "520 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food": "Sundal, 150 g white/yellow pumpkin (sambar/kootu), 100 g ladies finger poriyal, 100 g rice, 100 g kollu (horse gram)",
          "image": "assets/images/ladyfinger.jpg",
          "benefits": "Protein- and fiber-rich, boosts metabolism",
          "calories": "620 kcal"
        },
        {
          "type": "Snack ☕",
          "food": "Protein shake",
          "image": "assets/images/proteinshake.avif",
          "benefits": "Reduces insulin resistance and inflammation.",
          "calories": "170 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food": "Cauliflower rice pulao with veggies & 1 cup curd",
          "image": "assets/images/caulirice.jpeg",
          "benefits": "Low carb, fiber-rich, aids digestion",
          "calories": "400 kcal"
        },
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text("7-Day Weight Loss (Vegetarian)",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.deepPurple,
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
                      color: isSelected ? Colors.deepPurple : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected
                            ? Colors.deepPurple
                            : Colors.deepPurple.shade200,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        mealPlan[index]['day'],
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.deepPurple[800],
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
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.deepPurple)),
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
                            style: const TextStyle(
                                color: Colors.deepPurple,
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
