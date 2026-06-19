import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/day_plan.dart';
import '../models/diet_plan_filters.dart';

class MealPlanService {
  MealPlanService._();

  /// Returns the selected 7-day meal plan.
  static Future<List<DayPlan>> getMealPlans({
    required Goal goal,
    required Lifestyle lifestyle,
    required DietType dietType,
  }) async {
    // Currently only Weight Loss is available.
    if (!goal.isAvailable) {
      throw Exception(
        '${goal.label} meal plans are not available yet.',
      );
    }

    final jsonPath = _getJsonPath(dietType);

    final jsonString = await rootBundle.loadString(jsonPath);

    final Map<String, dynamic> data = json.decode(jsonString);

    final plans = data['plans'] as Map<String, dynamic>;

    final lifestylePlans =
        plans[lifestyle.jsonKey] as List<dynamic>?;

    if (lifestylePlans == null) {
      throw Exception(
        'No meal plans found for ${lifestyle.label}.',
      );
    }

    return lifestylePlans
        .map(
          (e) => DayPlan.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  static String _getJsonPath(DietType type) {
    switch (type) {
      case DietType.vegetarian:
        return 'assets/data/weight_loss_vegetarian.json';

      case DietType.eggetarian:
        return 'assets/data/weight_loss_eggetarian.json';

      case DietType.nonVegetarian:
        return 'assets/data/weight_loss_nonvegetarian.json';
    }
  }
}
