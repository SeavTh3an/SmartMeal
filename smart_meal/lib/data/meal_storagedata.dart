import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/meal.dart';

class MealStorage {
  static const String _key = 'user_meals';

  static Future<List<Meal>> loadUserMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) return [];

    final List data = jsonDecode(jsonString);
    return data.map((e) => Meal.fromJson(e)).toList();
  }

  static Future<void> saveUserMeals(List<Meal> meals) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(meals.map((m) => m.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }
}
