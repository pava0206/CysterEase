import 'meal.dart';

class DayPlan {
  final int dayNumber;
  final Meal breakfast;
  final Meal midMorningSnack;
  final Meal lunch;
  final Meal eveningSnack;
  final Meal dinner;
  final int dailyCalories;
  final String waterReminder;
  final String dailyTip;

  const DayPlan({
    required this.dayNumber,
    required this.breakfast,
    required this.midMorningSnack,
    required this.lunch,
    required this.eveningSnack,
    required this.dinner,
    required this.dailyCalories,
    required this.waterReminder,
    required this.dailyTip,
  });

  List<Meal> get allMeals =>
      [breakfast, midMorningSnack, lunch, eveningSnack, dinner];

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    final mealsJson = json['meals'] as Map<String, dynamic>;
    return DayPlan(
      dayNumber: json['dayNumber'] as int,
      breakfast:
          Meal.fromJson(mealsJson['breakfast'] as Map<String, dynamic>),
      midMorningSnack:
          Meal.fromJson(mealsJson['midMorningSnack'] as Map<String, dynamic>),
      lunch: Meal.fromJson(mealsJson['lunch'] as Map<String, dynamic>),
      eveningSnack:
          Meal.fromJson(mealsJson['eveningSnack'] as Map<String, dynamic>),
      dinner: Meal.fromJson(mealsJson['dinner'] as Map<String, dynamic>),
      dailyCalories: json['dailyCalories'] as int,
      waterReminder: json['waterReminder'] as String,
      dailyTip: json['dailyTip'] as String,
    );
  }
}