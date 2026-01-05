import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/meal.dart';

class MealLoader {
  static Future<List<Meal>> loadMeals() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/meals.json');

    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList.map((json) => Meal.fromJson(json)).toList();
  }
}
