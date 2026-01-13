import 'package:flutter/material.dart';

import '../../model/dailyLog.dart';
import '../../model/nutrition.dart';
import '../../model/meal.dart';
import '../../model/selectedMeal.dart';

import '../widget/home/todaySummaryCard.dart';
import '../widget/home/todayWarningCard.dart';
import '../widget/home/weeklySummary.dart';
import '../widget/header/homeHeader.dart';
import '../widget/home/homeToggleTab.dart'; // <-- import the enum from here

import '../../data/meal_loader.dart';
import '../../data/meal_storagedata.dart'; // optional (for user-created meals)
import '../../data/nutrition_tracker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  HomeView _view = HomeView.today;
  bool _loading = true;
  Map<String, Meal> _mealsById = {};
  List<SelectedMeal> _selectedMeals = [];
  late DailyLog _todayLog;
  late List<DailyLog> _weeklyLogs;
  final NutritionTracker _nutritionTracker = NutritionTracker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Refresh when returning to foreground (e.g., after logging a meal).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    // 1) Load meals (assets + runtime + optional user meals).
    final assetMeals = await MealLoader.loadMeals();
    final userMeals = await MealStorage.loadUserMeals(); // optional
    final allMeals = [...assetMeals, ...userMeals];

    final map = <String, Meal>{for (final m in allMeals) m.id: m};

    // 2) Load user-selected meals from SharedPreferences.
    final selections = await MealLoader().loadSelectedMeals();

    // 3) Compute today & weekly logs.
    final today = DateTime.now();
    final todayLog = _buildDailyLog(today, selections, map);
    final weeklyLogs = _buildWeeklyLogs(today, selections, map); // last 7 days

    setState(() {
      _mealsById = map;
      _selectedMeals = selections;
      _todayLog = todayLog;
      _weeklyLogs = weeklyLogs;
      _loading = false;
    });
  }

  Future<void> _pullToRefresh() => _loadData();

  DailyLog _buildDailyLog(
    DateTime date,
    List<SelectedMeal> selections,
    Map<String, Meal> mealMap,
  ) {
    final day = DateTime(date.year, date.month, date.day);
    double c = 0, p = 0, s = 0, f = 0;
    bool veg = false;

    for (final sel in selections) {
      final selDay = DateTime(sel.date.year, sel.date.month, sel.date.day);
      if (selDay != day) continue;

      final meal = mealMap[sel.mealId];
      if (meal == null) continue;

      final n = meal.nutrition;
      c += n.calories;
      p += n.protein;
      s += n.sugar;
      f += n.fat;
      veg = veg || n.vegetables;
    }

    return DailyLog(
      date: day,
      total: Nutrition(
        calories: c,
        protein: p,
        sugar: s,
        fat: f,
        vegetables: veg,
      ),
    );
  }

  List<DailyLog> _buildWeeklyLogs(
    DateTime endDate,
    List<SelectedMeal> selections,
    Map<String, Meal> mealMap,
  ) {
    // Monday of current week
    final today = DateTime(endDate.year, endDate.month, endDate.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));

    final out = <DailyLog>[];
    for (int i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      out.add(_buildDailyLog(day, selections, mealMap));
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _pullToRefresh,
        child: ValueListenableBuilder<List<Meal>>(
          valueListenable: _nutritionTracker.selectedMealsNotifier,
          builder: (context, selectedMeals, _) {
            // Calculate today's nutrition from selectedMeals
            final today = DateTime.now();
            double c = 0, p = 0, s = 0, f = 0;
            bool veg = false;
            for (final meal in selectedMeals) {
              final n = meal.nutrition;
              if (n == null) continue;
              c += n.calories;
              p += n.protein;
              s += n.sugar;
              f += n.fat;
              veg = veg || n.vegetables;
            }
            final todayLog = DailyLog(
              date: today,
              total: Nutrition(
                calories: c,
                protein: p,
                sugar: s,
                fat: f,
                vegetables: veg,
              ),
            );
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                HomeHeader(
                  title: 'Your Nutrition Overview',
                  imagePath: 'assets/image/western_img/salad_header.png',
                ),
                const SizedBox(height: 12),
                // Toggle: Today / Weekly
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HomeToggleTab(
                    current: _view,
                    onChanged: (v) => setState(() => _view = v),
                  ),
                ),
                const SizedBox(height: 12),
                if (_view == HomeView.today) ...[
                  TodaySummaryCard(log: todayLog),
                  const SizedBox(height: 12),
                  TodayWarningCard(log: todayLog),
                ] else ...[
                  // Recalculate weekly logs from selectedMeals
                  WeeklySummary(
                    weeklyLogs: _buildWeeklyLogs(
                      DateTime.now(),
                      // Simulate SelectedMeal list from selectedMeals (today all selected)
                      selectedMeals
                          .map(
                            (meal) => SelectedMeal(
                              id: meal.id + DateTime.now().toIso8601String(),
                              mealId: meal.id,
                              mealTime:
                                  MealTime.lunch, // Default or change as needed
                              date: DateTime.now(),
                            ),
                          )
                          .toList(),
                      {for (final m in selectedMeals) m.id: m},
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}
