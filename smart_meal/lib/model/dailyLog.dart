import 'meal.dart';
import 'nutrition.dart';
import 'recommendation.dart';

class DailyLog {
  final DateTime date;
  final Nutrition total;
  final List<Meal> meals; // <-- keep selected meals

  const DailyLog({
    required this.date,
    required this.total,
    this.meals = const [],
  });

  factory DailyLog.fromMeals(DateTime date, List<Meal> selectedMeals) {
    double calories = 0, protein = 0, sugar = 0, fat = 0;
    bool vegetables = false;

    for (final m in selectedMeals) {
      calories += m.nutrition.calories;
      protein += m.nutrition.protein;
      sugar += m.nutrition.sugar;
      fat += m.nutrition.fat;
      vegetables = vegetables || m.nutrition.vegetables;
    }

    return DailyLog(
      date: date,
      total: Nutrition(
        calories: calories,
        protein: protein,
        sugar: sugar,
        fat: fat,
        vegetables: vegetables,
      ),
      meals: selectedMeals,
    );
  }

  // --- Warnings ---
  bool get isCaloriesHigh => total.calories > Recommendation.calories;
  bool get isSugarHigh    => total.sugar > Recommendation.sugar;
  bool get isFatHigh      => total.fat > Recommendation.fat;

  // --- Status ---
  String get status {
    if (isCaloriesHigh || isSugarHigh || isFatHigh) return 'Warning';

    final nearLimit =
        total.calories >= 0.8 * Recommendation.calories ||
        total.sugar    >= 0.8 * Recommendation.sugar ||
        total.fat      >= 0.8 * Recommendation.fat;

    if (nearLimit) return 'Moderate';
    return 'Healthy';
  }

  // --- Daily Suggestions ---
  List<String> suggestions() {
    final tips = <String>[];

    if (total.sugar > Recommendation.sugar) tips.add('Reduce sugar intake today.');
    if (total.fat > Recommendation.fat) tips.add('Reduce fried or oily food today.');
    if (total.calories > Recommendation.calories) tips.add('Consider smaller portions today.');
    if (!total.vegetables) tips.add('Add some vegetables to your meals.');

    if (tips.isEmpty) tips.add('Great choices today! Keep it up.');

    return tips;
  }

  // --- Weekly aggregation ---
  static Nutrition weeklyTotal(List<DailyLog> logs) {
    double c = 0, p = 0, s = 0, f = 0;
    bool veg = false;

    for (final d in logs) {
      c += d.total.calories;
      p += d.total.protein;
      s += d.total.sugar;
      f += d.total.fat;
      veg = veg || d.total.vegetables;
    }

    return Nutrition(
      calories: c,
      protein: p,
      sugar: s,
      fat: f,
      vegetables: veg,
    );
  }
}

// --- Weekly Suggestions ---
extension WeeklySuggestions on List<DailyLog> {
  List<String> suggestions() {
    final total = DailyLog.weeklyTotal(this);
    final tips = <String>[];

    if (total.sugar > Recommendation.sugar * length) tips.add('Reduce sugar intake this week.');
    if (total.fat > Recommendation.fat * length) tips.add('Reduce fried or oily food this week.');
    if (total.calories > Recommendation.calories * length) tips.add('Consider smaller portions or light exercise this week.');
    if (!total.vegetables) tips.add('Add more vegetables this week.');

    if (tips.isEmpty) tips.add('Great balance this week! Keep it up.');

    return tips;
  }
}
