import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/meal.dart';

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
}
