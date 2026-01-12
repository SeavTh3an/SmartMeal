import 'nutrition.dart';
import 'recommendation.dart';

class DailyLog {
  final DateTime date;
  final Nutrition total;

  const DailyLog({
    required this.date,
    required this.total,
  });

  // ----------- Warnings -----------

  bool get isCaloriesHigh => total.calories > Recommendation.calories;
  bool get isSugarHigh    => total.sugar > Recommendation.sugar;
  bool get isFatHigh      => total.fat > Recommendation.fat;

  // ----------- Daily Status -----------

  String get status {
    if (isCaloriesHigh || isSugarHigh || isFatHigh) return 'Warning';

    final nearLimit =
        total.calories >= 0.8 * Recommendation.calories ||
        total.sugar    >= 0.8 * Recommendation.sugar ||
        total.fat      >= 0.8 * Recommendation.fat;

    if (nearLimit) return 'Moderate';
    return 'Healthy';
  }

  // ----------- Weekly Aggregation -----------

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

// ----------- Weekly Suggestions Extension -----------

extension WeeklySuggestions on List<DailyLog> {
  List<String> suggestions() {
    final total = DailyLog.weeklyTotal(this);
    final tips = <String>[];

    if (total.sugar > Recommendation.sugar * length) {
      tips.add('Reduce sugar intake this week.');
    }
    if (total.fat > Recommendation.fat * length) {
      tips.add('Reduce fried or oily food.');
    }
    if (total.calories > Recommendation.calories * length) {
      tips.add('Consider smaller portions or light exercise.');
    }
    if (tips.isEmpty) {
      tips.add('Great balance this week! Keep it up.');
    }

    return tips;
  }
}
