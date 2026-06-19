import 'meal.dart';

class MealMatch {
  final Meal meal;
  final double matchPercentage;
  final List<String> matchedIngredients;
  final List<String> missingIngredients;

  const MealMatch({
    required this.meal,
    required this.matchPercentage,
    required this.matchedIngredients,
    required this.missingIngredients,
  });
}