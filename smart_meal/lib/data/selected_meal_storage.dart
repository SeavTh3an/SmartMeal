import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/selectedMeal.dart';

class SelectedMealStorage {
  static const String _key = 'selected_meal_entries';

  // Load selected meal entries
  static Future<List<SelectedMeal>> loadSelectedMealEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) return [];

    final List data = jsonDecode(jsonString);
    return data.map((e) => SelectedMeal.fromJson(e)).toList();
  }

  // Save selected meal entries
  static Future<void> saveSelectedMealEntries(
    List<SelectedMeal> entries,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }
}
