import 'package:flutter/material.dart';

import '../models/day_plan.dart';
import '../models/diet_plan_filters.dart';
import '../services/meal_plan_service.dart';
import '../widgets/day_selector.dart';
import '../widgets/daily_summary_card.dart';
import '../widgets/meal_card.dart';

class MealPlanScreen extends StatefulWidget {
  final Goal goal;
  final Lifestyle lifestyle;
  final DietType dietType;

  const MealPlanScreen({
    super.key,
    required this.goal,
    required this.lifestyle,
    required this.dietType,
  });

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  bool _isLoading = true;
  String? _error;

  List<DayPlan> _plans = [];

  int _selectedDay = 1;

  @override
  void initState() {
    super.initState();
    _loadMealPlans();
  }

  Future<void> _loadMealPlans() async {
    try {
      final plans = await MealPlanService.getMealPlans(
        goal: widget.goal,
        lifestyle: widget.lifestyle,
        dietType: widget.dietType,
      );

      setState(() {
        _plans = plans;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  DayPlan get currentPlan =>
      _plans.firstWhere((plan) => plan.dayNumber == _selectedDay);

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("7-Day Meal Plan"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("7-Day Meal Plan"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _error!,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final day = currentPlan;
        return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.goal.label} Meal Plan",
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              8,
            ),
            child: DaySelector(
              selectedDay: _selectedDay,
              onDaySelected: (dayNumber) {
                setState(() {
                  _selectedDay = dayNumber;
                });
              },
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  DailySummaryCard(
                    totalCalories: day.dailyCalories,
                    waterReminder: day.waterReminder,
                    dailyTip: day.dailyTip,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Meals",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  MealCard(
                    meal: day.breakfast,
                  ),

                  MealCard(
                    meal: day.midMorningSnack,
                  ),

                  MealCard(
                    meal: day.lunch,
                  ),

                  MealCard(
                    meal: day.eveningSnack,
                  ),

                  MealCard(
                    meal: day.dinner,
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: Text(
                      "End of Day ${day.dayNumber}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                                  ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: _loadMealPlans,
        tooltip: 'Reload Meal Plan',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}