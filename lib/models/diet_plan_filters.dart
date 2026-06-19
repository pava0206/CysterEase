import 'package:flutter/material.dart';

enum Goal {
  weightLoss,
  weightGain,
  weightMaintenance,
  improveInsulinResistance,
  hormonalBalance,
}

enum Lifestyle {
  collegeStudent,
  hostelStudent,
  officeWorker,
  homemaker,
  livingAlone,
}

enum DietType {
  vegetarian,
  eggetarian,
  nonVegetarian,
}

extension GoalExtension on Goal {
  String get label {
    switch (this) {
      case Goal.weightLoss:
        return 'Weight Loss';
      case Goal.weightGain:
        return 'Weight Gain';
      case Goal.weightMaintenance:
        return 'Weight Maintenance';
      case Goal.improveInsulinResistance:
        return 'Improve Insulin Resistance';
      case Goal.hormonalBalance:
        return 'Hormonal Balance';
    }
  }

  String get subtitle {
    switch (this) {
      case Goal.weightLoss:
        return 'Reduce fat with balanced PCOS-friendly meals';
      case Goal.weightGain:
        return 'Build healthy weight sustainably';
      case Goal.weightMaintenance:
        return 'Maintain your current healthy weight';
      case Goal.improveInsulinResistance:
        return 'Stabilise blood sugar and insulin levels';
      case Goal.hormonalBalance:
        return 'Support hormone regulation naturally';
    }
  }

  IconData get icon {
    switch (this) {
      case Goal.weightLoss:
        return Icons.monitor_weight_outlined;
      case Goal.weightGain:
        return Icons.trending_up_rounded;
      case Goal.weightMaintenance:
        return Icons.balance_rounded;
      case Goal.improveInsulinResistance:
        return Icons.water_drop_outlined;
      case Goal.hormonalBalance:
        return Icons.favorite_border_rounded;
    }
  }

  String get jsonKey {
    switch (this) {
      case Goal.weightLoss:
        return 'weight_loss';
      case Goal.weightGain:
        return 'weight_gain';
      case Goal.weightMaintenance:
        return 'weight_maintenance';
      case Goal.improveInsulinResistance:
        return 'insulin_resistance';
      case Goal.hormonalBalance:
        return 'hormonal_balance';
    }
  }

  bool get isAvailable => this == Goal.weightLoss;
}

extension LifestyleExtension on Lifestyle {
  String get label {
    switch (this) {
      case Lifestyle.collegeStudent:
        return 'College Student';
      case Lifestyle.hostelStudent:
        return 'Hostel Student';
      case Lifestyle.officeWorker:
        return 'Office Worker';
      case Lifestyle.homemaker:
        return 'Homemaker';
      case Lifestyle.livingAlone:
        return 'Living Alone';
    }
  }

  String get subtitle {
    switch (this) {
      case Lifestyle.collegeStudent:
        return 'Affordable, filling, easy to prepare near campus';
      case Lifestyle.hostelStudent:
        return 'Budget-friendly, mess-compatible, minimal cooking';
      case Lifestyle.officeWorker:
        return 'Lunchbox meals, quick breakfast, healthy snacks';
      case Lifestyle.homemaker:
        return 'Home-cooked balanced meals, slightly elaborate';
      case Lifestyle.livingAlone:
        return 'One-pot meals, less wastage, simple prep';
    }
  }

  IconData get icon {
    switch (this) {
      case Lifestyle.collegeStudent:
        return Icons.school_outlined;
      case Lifestyle.hostelStudent:
        return Icons.apartment_outlined;
      case Lifestyle.officeWorker:
        return Icons.work_outline_rounded;
      case Lifestyle.homemaker:
        return Icons.home_outlined;
      case Lifestyle.livingAlone:
        return Icons.person_outline_rounded;
    }
  }

  String get jsonKey {
    switch (this) {
      case Lifestyle.collegeStudent:
        return 'college_student';
      case Lifestyle.hostelStudent:
        return 'hostel_student';
      case Lifestyle.officeWorker:
        return 'office_worker';
      case Lifestyle.homemaker:
        return 'homemaker';
      case Lifestyle.livingAlone:
        return 'living_alone';
    }
  }
}

extension DietTypeExtension on DietType {
  String get label {
    switch (this) {
      case DietType.vegetarian:
        return 'Vegetarian';
      case DietType.eggetarian:
        return 'Eggetarian';
      case DietType.nonVegetarian:
        return 'Non-Vegetarian';
    }
  }

  String get subtitle {
    switch (this) {
      case DietType.vegetarian:
        return 'Plant-based meals rich in iron & fibre';
      case DietType.eggetarian:
        return 'Egg-powered protein with Indian superfoods';
      case DietType.nonVegetarian:
        return 'High-protein chicken, fish & seafood meals';
    }
  }

  IconData get icon {
    switch (this) {
      case DietType.vegetarian:
        return Icons.eco_outlined;
      case DietType.eggetarian:
        return Icons.egg_outlined;
      case DietType.nonVegetarian:
        return Icons.restaurant_outlined;
    }
  }

  String get jsonKey {
    switch (this) {
      case DietType.vegetarian:
        return 'vegetarian';
      case DietType.eggetarian:
        return 'eggetarian';
      case DietType.nonVegetarian:
        return 'non_vegetarian';
    }
  }
}