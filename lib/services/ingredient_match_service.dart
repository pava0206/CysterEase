import '../models/day_plan.dart';
import '../models/meal_match.dart';

class IngredientMatchService {
  IngredientMatchService._();

  static List<MealMatch> findMatchingMeals({
    required List<DayPlan> dayPlans,
    required List<String> userIngredients,
  }) {
    final normalizedIngredients = userIngredients
        .map((e) => e.toLowerCase().trim())
        .toList();

    final List<MealMatch> matches = [];

    for (final day in dayPlans) {
      for (final meal in day.allMeals) {
        final mealIngredients = meal.ingredients
            .map((e) => e.toLowerCase().trim())
            .toList();

        final matched = mealIngredients
            .where((ingredient) => normalizedIngredients.contains(ingredient))
            .toList();

        final missing = mealIngredients
            .where((ingredient) => !normalizedIngredients.contains(ingredient))
            .toList();

        final percentage =
            (matched.length / mealIngredients.length) * 100;

        matches.add(
          MealMatch(
            meal: meal,
            matchPercentage: percentage,
            matchedIngredients: matched,
            missingIngredients: missing,
          ),
        );
      }
    }

    matches.sort(
      (a, b) =>
          b.matchPercentage.compareTo(a.matchPercentage),
    );

    return matches;
  }
}