class AffordableSwap {
  final String original;
  final String swap;

  const AffordableSwap({required this.original, required this.swap});

  factory AffordableSwap.fromJson(Map<String, dynamic> json) {
    return AffordableSwap(
      original: json['original'] as String,
      swap: json['swap'] as String,
    );
  }
}

class Meal {
  final String mealType; // breakfast | midMorningSnack | lunch | eveningSnack | dinner
  final String mealName;
  final List<String> ingredients;
  final int calories;
  final String benefit;
  final int prepTimeMinutes;
  final String difficulty; // Easy | Medium | Hard
  final List<AffordableSwap> affordableSwaps;

  const Meal({
    required this.mealType,
    required this.mealName,
    required this.ingredients,
    required this.calories,
    required this.benefit,
    required this.prepTimeMinutes,
    required this.difficulty,
    required this.affordableSwaps,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealType: json['mealType'] as String,
      mealName: json['mealName'] as String,
      ingredients: List<String>.from(json['ingredients'] as List),
      calories: json['calories'] as int,
      benefit: json['benefit'] as String,
      prepTimeMinutes: json['prepTimeMinutes'] as int,
      difficulty: json['difficulty'] as String,
      affordableSwaps: (json['affordableSwaps'] as List? ?? [])
          .map((e) => AffordableSwap.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}