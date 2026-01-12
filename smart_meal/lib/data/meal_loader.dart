import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/meal.dart';
import '../model/selectedMeal.dart';

class MealLoader {
  static final List<Meal> _runtimeMeals = [];

  static Future<List<Meal>> loadMeals() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/meals.json');

    final List<dynamic> jsonList = jsonDecode(jsonString);

    final jsonMeals = jsonList.map((json) => Meal.fromJson(json)).toList();

    //combine JSON meals + runtime meals
    return [...jsonMeals, ..._runtimeMeals];
  }

  //add meal temporarily
  static void addMeal(Meal meal) {
    _runtimeMeals.add(meal);
  }
  
  static const _kSelectedMealsKey = 'selected_meals';

Future<void> saveSelectedMeal(SelectedMeal sel) async {
  final prefs = await SharedPreferences.getInstance();
  final list = prefs.getStringList(_kSelectedMealsKey) ?? <String>[];
  list.add(jsonEncode(sel.toJson()));
  await prefs.setStringList(_kSelectedMealsKey, list);
}

Future<List<SelectedMeal>> loadSelectedMeals() async {
  final prefs = await SharedPreferences.getInstance();
  final list = prefs.getStringList(_kSelectedMealsKey) ?? <String>[];
  return list.map((s) => SelectedMeal.fromJson(jsonDecode(s))).toList();
}
}
