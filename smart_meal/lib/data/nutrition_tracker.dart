import 'package:smart_meal/model/meal.dart';
import 'package:smart_meal/model/nutrition.dart';
import 'package:flutter/foundation.dart';

class NutritionTracker {
  static final NutritionTracker _instance = NutritionTracker._internal();
  factory NutritionTracker() => _instance;
  NutritionTracker._internal();

  // stores a list of selected meals and automatically updates
  final ValueNotifier<List<Meal>> selectedMealsNotifier =
      ValueNotifier<List<Meal>>([]);

  void addMeal(Meal meal) {
    selectedMealsNotifier.value =
        List.from(selectedMealsNotifier.value)..add(meal);
  }

  void removeMeal(Meal meal) {
    selectedMealsNotifier.value =
        List.from(selectedMealsNotifier.value)..remove(meal);
  }

  // Read only access
  List<Meal> get selectedMeals =>
      List.unmodifiable(selectedMealsNotifier.value);

  // Calculate total nutrition dynamically
  Nutrition get totalNutrition {
    double calories = 0, protein = 0, sugar = 0, fat = 0;
    bool vegetables = false;

    for (final meal in selectedMealsNotifier.value) {
      final n = meal.nutrition;
      calories += n.calories; 
      protein += n.protein;
      sugar += n.sugar;
      fat += n.fat;
      vegetables = vegetables || n.vegetables;
    }

    return Nutrition(
      calories: calories,
      protein: protein,
      sugar: sugar,
      fat: fat,
      vegetables: vegetables,
    );
  }

  void clear() {
    selectedMealsNotifier.value = [];
  }
}
