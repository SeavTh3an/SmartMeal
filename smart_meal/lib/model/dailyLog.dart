import 'nutrition.dart';

class DailyLog {
  final Nutrition total;

  DailyLog(this.total);

  bool get isSugarHigh => total.sugar > 25;
  bool get isFatHigh => total.fat > 70;
  bool get isCaloriesHigh => total.calories > 2000;
}
