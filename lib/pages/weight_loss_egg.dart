import 'package:flutter/material.dart';

class WeightLossEggPage extends StatefulWidget {
  const WeightLossEggPage({super.key});

  @override
  State<WeightLossEggPage> createState() => _WeightLossEggPageState();
}

class _WeightLossEggPageState extends State<WeightLossEggPage> {
  int selectedDay = 0;

  final List<Map<String, dynamic>> mealPlan = [
    // ─────────────────────────────────────────
    // DAY 1
    // ─────────────────────────────────────────
    {
      "day": "Day 1",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food":
              "2 whole eggs scrambled with onion, tomato & curry leaves + 2 small whole wheat dosas + 1 glass warm jeera water",
          "image": "assets/images/egg_dosa.jpg",
          "benefits":
              "Eggs provide complete protein and choline for hormonal balance; whole wheat dosas give slow-release energy to prevent blood sugar spikes common in PCOS.",
          "calories": "~355 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food":
              "Brown rice (½ cup) + Drumstick (murungakkai) sambar + Vazhaithandu (banana stem) kootu + plain curd",
          "image": "assets/images/brown_rice_sambar.jpg",
          "benefits":
              "Banana stem is a natural diuretic rich in fiber that reduces PCOS-driven water retention; drumstick pods supply zinc and iron for ovarian health.",
          "calories": "~490 kcal"
        },
        {
          "type": "Snack 🥜",
          "food":
              "Moong dal (pasiparuppu) sundal with grated coconut + 1 boiled egg + squeeze of lemon",
          "image": "assets/images/moong_sundal_egg.jpg",
          "benefits":
              "Boiled egg's vitamin D activates progesterone receptors; moong dal's resistant starch stabilises blood sugar and curbs mid-afternoon cravings.",
          "calories": "~195 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food":
              "Ragi mudde (2 nos) + Keerai masiyal (spinach mash with garlic) + 1 egg curry (light gravy) + clear rasam",
          "image": "assets/images/ragi_keerai_egg.jpg",
          "benefits":
              "Ragi's low glycemic index promotes overnight satiety; spinach iron + egg B12 together combat the anemia frequently seen in PCOS women.",
          "calories": "~365 kcal"
        },
      ]
    },

    // ─────────────────────────────────────────
    // DAY 2
    // ─────────────────────────────────────────
    {
      "day": "Day 2",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food":
              "Idli (3 nos) + egg bhurji (2 eggs scrambled with tomato & onion) + sambar + 1 tsp ground flax seeds sprinkled",
          "image": "assets/images/idli_egg_bhurji.jpg",
          "benefits":
              "Fermented idli improves gut microbiome health; flax seeds provide lignans that directly reduce excess estrogen levels driving PCOS symptoms.",
          "calories": "~370 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food":
              "Thinai (foxtail millet) rice + Poricha kootu (mixed veg + coconut + cumin) + Mor kuzhambu (buttermilk curry) + raw cucumber salad",
          "image": "assets/images/millet_rice_kootu.jpg",
          "benefits":
              "Foxtail millet has a low glycemic index and is rich in iron — both critical for managing the insulin resistance at the root of PCOS.",
          "calories": "~450 kcal"
        },
        {
          "type": "Snack 🥜",
          "food":
              "1 hard-boiled egg + roasted peanuts (small handful) + 1 cup spearmint green tea (no sugar)",
          "image": "assets/images/egg_peanuts_tea.jpg",
          "benefits":
              "Spearmint tea is clinically proven to reduce free testosterone in PCOS women; peanuts provide healthy monounsaturated fats for hormone synthesis.",
          "calories": "~190 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food":
              "Pesarattu (green moong dal dosa, 2 nos) + 1-egg side omelette with curry leaves + ginger-mint chutney + vegetable soup",
          "image": "assets/images/pesarattu_egg.jpg",
          "benefits":
              "Moong dal is high in folate supporting ovarian health; egg's B6 is critical for progesterone production in the luteal phase.",
          "calories": "~375 kcal"
        },
      ]
    },

    // ─────────────────────────────────────────
    // DAY 3
    // ─────────────────────────────────────────
    {
      "day": "Day 3",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food":
              "Oats adai (mixed lentil + oat dosa, 2 nos) + 2 scrambled eggs with turmeric & pepper + tomato-coriander chutney",
          "image": "assets/images/oats_adai_egg.jpg",
          "benefits":
              "Turmeric's curcumin has potent anti-inflammatory action that directly eases PCOS-related inflammation; oats' beta-glucan lowers LDL cholesterol.",
          "calories": "~340 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food":
              "Varagu (kodo millet) rice + Kathirikkai (brinjal) gothsu + Toor dal paruppu + 1 boiled egg side + plain curd",
          "image": "assets/images/kodo_millet_gothsu.jpg",
          "benefits":
              "Kodo millet's phytochemicals lower cholesterol and blood sugar; egg alongside dal creates a complete amino acid profile for muscle preservation.",
          "calories": "~480 kcal"
        },
        {
          "type": "Snack 🥜",
          "food":
              "Chia seed pudding (1 tbsp chia + coconut milk) + 1 boiled egg + roasted pumpkin seeds (1 tbsp)",
          "image": "assets/images/chia_egg_snack.jpg",
          "benefits":
              "Pumpkin seeds are the richest plant source of zinc, directly suppressing ovarian androgen production; chia omega-3 reduces follicular inflammation.",
          "calories": "~210 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food":
              "Palak egg masala (2 eggs in spinach gravy, light oil) + 2 small whole wheat phulkas + small cucumber raita",
          "image": "assets/images/palak_egg_curry.jpg",
          "benefits":
              "Spinach folate and egg choline together support the methylation cycle critical for healthy hormonal signalling and ovarian function.",
          "calories": "~395 kcal"
        },
      ]
    },

    // ─────────────────────────────────────────
    // DAY 4
    // ─────────────────────────────────────────
    {
      "day": "Day 4",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food":
              "Kuthiraivali (barnyard millet) pongal with ghee, pepper & cumin + 2-egg side omelette with onion + warm jeera water",
          "image": "assets/images/millet_pongal_egg.jpg",
          "benefits":
              "Barnyard millet is gluten-free and low glycemic; ghee provides fat-soluble vitamins A, D, E, K needed for progesterone and estrogen synthesis.",
          "calories": "~360 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food":
              "Brown rice (½ cup) + Pavakkai (bitter gourd) pitlai + Murungai keerai (drumstick leaves) stir fry + 1 boiled egg + buttermilk",
          "image": "assets/images/bitter_gourd_egg_rice.jpg",
          "benefits":
              "Bitter gourd is clinically proven to improve insulin sensitivity — the root cause of PCOS weight gain; drumstick leaves add iron and calcium.",
          "calories": "~465 kcal"
        },
        {
          "type": "Snack 🥜",
          "food":
              "Sprouted horse gram (kollu) sundal with onion, tomato & coriander + 1 boiled egg white",
          "image": "assets/images/kollu_sundal_egg.jpg",
          "benefits":
              "Horse gram is thermogenic — it supports fat burning; egg white adds fat-free complete protein to keep the snack calorie-light and satisfying.",
          "calories": "~178 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food":
              "Egg keerai (spinach egg stir fry, 2 eggs) + Ragi adai (2 nos) + clear kollu (horse gram) rasam + small bowl plain curd",
          "image": "assets/images/egg_keerai_ragi.jpg",
          "benefits":
              "Ragi's calcium and iron with keerai's folate and egg's B12 address the three biggest micronutrient deficiencies in PCOS women.",
          "calories": "~355 kcal"
        },
      ]
    },

    // ─────────────────────────────────────────
    // DAY 5
    // ─────────────────────────────────────────
    {
      "day": "Day 5",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food":
              "Kambu (pearl millet) dosa (2 nos) + 2-egg bhurji with grated carrot & curry leaves + kadala (black chickpea) chutney",
          "image": "assets/images/kambu_dosa_egg.jpg",
          "benefits":
              "Pearl millet is highest in magnesium among millets — magnesium deficiency worsens PCOS; egg bhurji adds complete protein without extra carbs.",
          "calories": "~350 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food":
              "Samai (little millet) rice + Avarakkai (broad beans) kootu + Egg masala (1 egg, light gravy) + Tomato rasam + small curd",
          "image": "assets/images/little_millet_egg.jpg",
          "benefits":
              "Little millet's phosphorus and B vitamins support metabolism; broad beans are rich in plant protein that complements egg's animal protein.",
          "calories": "~465 kcal"
        },
        {
          "type": "Snack 🥜",
          "food":
              "Roasted makhana (fox nuts, 1 cup) + 1 hard-boiled egg + 1 cup cinnamon herbal tea (no sugar)",
          "image": "assets/images/makhana_egg_tea.jpg",
          "benefits":
              "Cinnamon is proven to improve menstrual regularity and insulin resistance in PCOS; makhana is low-calorie and high in magnesium.",
          "calories": "~185 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food":
              "Vendakkai (okra) sambar + 2 whole wheat egg dosas (1 egg in batter) + raw onion-tomato chutney + small bowl curd",
          "image": "assets/images/okra_sambar_egg_dosa.jpg",
          "benefits":
              "Okra is rich in soluble fiber and chromium that directly reduces the insulin resistance driving PCOS; egg dosa boosts protein density.",
          "calories": "~372 kcal"
        },
      ]
    },

    // ─────────────────────────────────────────
    // DAY 6
    // ─────────────────────────────────────────
    {
      "day": "Day 6",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food":
              "Methi (fenugreek) sprouted dosa (2 nos) + 2-egg white omelette with spinach & pepper + coconut chutney + warm turmeric milk",
          "image": "assets/images/methi_dosa_egg.jpg",
          "benefits":
              "Sprouted fenugreek seeds contain diosgenin that mimics progesterone activity; turmeric milk reduces systemic inflammation linked to PCOS.",
          "calories": "~365 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food":
              "Brown rice (½ cup) + Vazha poo (banana flower) egg stir fry (1 egg) + Manathakkali keerai (black nightshade leaves) poriyal + Tomato rasam",
          "image": "assets/images/vazha_poo_egg_rice.jpg",
          "benefits":
              "Banana flower regulates menstrual cycles and provides iron; manathakkali keerai reduces ovarian inflammation and supports liver hormone detox.",
          "calories": "~475 kcal"
        },
        {
          "type": "Snack 🥜",
          "food":
              "Mixed sprouts chaat (moong + chickpea sprouts + tomato, onion, lemon, cumin) + 1 boiled egg",
          "image": "assets/images/sprouts_egg_chaat.jpg",
          "benefits":
              "Sprouting increases bioavailability of zinc and folate; egg's complete protein paired with sprouts' plant protein creates a full amino acid snack.",
          "calories": "~198 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food":
              "Agathi keerai (hummingbird tree leaves) poriyal + 1 egg kootu (egg + mixed veg) + Toor dal + 1 whole wheat phulka + clear rasam",
          "image": "assets/images/agathi_egg_dal.jpg",
          "benefits":
              "Agathi keerai has calcium, iron, and phytoestrogens used in traditional medicine for hormonal balance; egg adds B12 for nerve and hormone health.",
          "calories": "~380 kcal"
        },
      ]
    },

    // ─────────────────────────────────────────
    // DAY 7
    // ─────────────────────────────────────────
    {
      "day": "Day 7",
      "meals": [
        {
          "type": "Breakfast 🍳",
          "food":
              "2-egg vegetable uttapam (with carrot, onion, tomato, coriander) + coconut chutney + sambar + 1 glass warm jeera water",
          "image": "assets/images/egg_uttapam.jpg",
          "benefits":
              "Egg-topped uttapam combines fermented carbs with complete protein for a balanced, hormone-stabilising start; jeera water improves insulin sensitivity.",
          "calories": "~360 kcal"
        },
        {
          "type": "Lunch 🥗",
          "food":
              "Thinai (foxtail millet) bisibelabath with mixed vegetables + 1 boiled egg side + papad + small cucumber raita",
          "image": "assets/images/millet_bisibelebath_egg.jpg",
          "benefits":
              "A one-pot millet + lentil meal provides a complete amino acid profile with low glycemic load; egg adds vitamin D for insulin receptor activation.",
          "calories": "~478 kcal"
        },
        {
          "type": "Snack 🥜",
          "food":
              "Chia seed + coconut milk mini pudding + 1 boiled egg + 2-3 pieces fresh coconut + roasted pumpkin seeds",
          "image": "assets/images/chia_egg_coconut.jpg",
          "benefits":
              "Chia omega-3 and egg DHA together maximise anti-inflammatory support for PCOS ovaries; coconut's medium-chain fats support progesterone production.",
          "calories": "~215 kcal"
        },
        {
          "type": "Dinner 🍛",
          "food":
              "Pesarattu (2 moong dal dosas) + 1-egg keerai (spinach) omelette + Kollu (horse gram) rasam + small plain curd bowl",
          "image": "assets/images/pesarattu_egg_keerai.jpg",
          "benefits":
              "A light, protein-rich dinner combining plant and egg protein promotes overnight fat burning while horse gram rasam is thermogenic and reduces water retention.",
          "calories": "~372 kcal"
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
          "7-Day Weight Loss (Eggitarian)",
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
                    "Tamil eggitarian meals · No meat/fish · PCOS-friendly · Low GI · Anti-inflammatory",
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
                        Divider(
                            color: Colors.deepPurple.shade100, height: 1),

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