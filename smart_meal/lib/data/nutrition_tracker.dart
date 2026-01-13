import 'package:smart_meal/model/meal.dart';
import 'package:smart_meal/model/nutrition.dart';
import 'package:flutter/foundation.dart';

class NutritionTracker {
  static final NutritionTracker _instance = NutritionTracker._internal();
  factory NutritionTracker() => _instance;
  NutritionTracker._internal();

  // Use ValueNotifier for instant UI updates
  final ValueNotifier<List<Meal>> selectedMealsNotifier =
      ValueNotifier<List<Meal>>([]);

  void addMeal(Meal meal) {
    final updated = List<Meal>.from(selectedMealsNotifier.value)..add(meal);
    selectedMealsNotifier.value = updated;
  }

  void removeMeal(Meal meal) {
    final updated = List<Meal>.from(selectedMealsNotifier.value)..remove(meal);
    selectedMealsNotifier.value = updated;
  }

  List<Meal> get selectedMeals =>
      List.unmodifiable(selectedMealsNotifier.value);

  Nutrition get totalNutrition {
    double calories = 0;
    double protein = 0;
    double sugar = 0;
    double fat = 0;
    bool vegetables = false;
    for (final meal in selectedMealsNotifier.value) {
      final n = meal.nutrition;
      if (n == null) continue;
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
