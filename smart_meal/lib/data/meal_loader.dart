import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/meal.dart';
import '../model/selectedMeal.dart';

class MealLoader {
  static final List<Meal> _runtimeMeals = [];

  static Future<List<Meal>> loadMeals() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/meals.json',
    );

    final List<dynamic> jsonList = jsonDecode(jsonString);

    final jsonMeals = jsonList.map((json) => Meal.fromJson(json)).toList();

    //combine JSON meals 
    return [...jsonMeals, ];
  }


  static const _kSelectedMealsKey = 'selected_meals';

  get meals => null;

  Future<void> saveSelectedMeal(SelectedMeal sel) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kSelectedMealsKey) ?? <String>[];
    list.add(jsonEncode(sel.toJson()));
    await prefs.setStringList(_kSelectedMealsKey, list);
  }

  /// Overwrite all saved selected meals.
  Future<void> saveAllSelectedMeals(List<SelectedMeal> sels) async {
    final prefs = await SharedPreferences.getInstance();
    final list = sels.map((s) => jsonEncode(s.toJson())).toList();
    // debug: show what we are saving
    debugPrint(
      'MealLoader.saveAllSelectedMeals: saving ${list.length} entries',
    );
    if (list.isNotEmpty)
      debugPrint('MealLoader.saveAllSelectedMeals: ${list.join(" | ")}');
    await prefs.setStringList(_kSelectedMealsKey, list);
  }

  Future<List<SelectedMeal>> loadSelectedMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kSelectedMealsKey) ?? <String>[];
    // debug: show what we loaded raw
    debugPrint(
      'MealLoader.loadSelectedMeals: loaded raw list length=${list.length}',
    );
    if (list.isNotEmpty)
      debugPrint('MealLoader.loadSelectedMeals: ${list.join(" | ")}');
    return list.map((s) => SelectedMeal.fromJson(jsonDecode(s))).toList();
  }
}
