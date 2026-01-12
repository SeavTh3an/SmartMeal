
enum MealTime { breakfast, lunch, dinner }

class SelectedMeal {
  final String id;
  final String mealId; // use String to match common Meal.id; change if your Meal.id is int
  final MealTime mealTime;
  final DateTime date;

  SelectedMeal({
    required this.id,
    required this.mealId,
    required this.mealTime,
    required this.date,
  });

  factory SelectedMeal.fromJson(Map<String, dynamic> json) => SelectedMeal(
        id: json['id'] as String,
        mealId: json['mealId'].toString(),
        mealTime: MealTime.values[json['mealTime'] as int],
        date: DateTime.parse(json['date'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'mealId': mealId,
        'mealTime': mealTime.index,
        'date': date.toIso8601String(),
      };

  String get label {
    switch (mealTime) {
      case MealTime.breakfast:
        return 'Breakfast';
      case MealTime.lunch:
        return 'Lunch';
      case MealTime.dinner:
        return 'Dinner';
    }
  }
}