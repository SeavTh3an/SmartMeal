import 'package:flutter/material.dart';

import '../../model/dailyLog.dart';
import '../../model/nutrition.dart';
import '../../model/meal.dart';
import '../../model/selectedMeal.dart';

import '../widget/home/todaySummaryCard.dart';
import '../widget/home/todayWarningCard.dart';
import '../widget/home/weeklySummary.dart';
import '../widget/header/homeHeader.dart';
import '../widget/home/homeToggleTab.dart'; 

import '../../data/meal_loader.dart';
import '../../data/meal_storagedata.dart'; 
import '../../data/nutrition_tracker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  //State variable
  HomeView _view = HomeView.today; // Current tab: Today or Weekly
  bool _loading = true; // Loading indicator
  final NutritionTracker _nutritionTracker = NutritionTracker(); //tracker

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); //Listen to app lifecycle
    _loadData(); // Load meals and user selection
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Refresh when app returns to foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadData();
    }
  }

  // Load all meals and user selections 
  Future<void> _loadData() async {
    setState(() => _loading = true);

    final assetMeals = await MealLoader.loadMeals();
    final userMeals = await MealStorage.loadUserMeals();
    final allMeals = [...assetMeals, ...userMeals];

    // Create a map for fast lookup by meal ID
    final map = {for (final m in allMeals) m.id: m};

    // Load selected meals (history) from storage
    final selections = await MealLoader().loadSelectedMeals();

    // Build today's and weekly logs
    _buildDailyLog(DateTime.now(), selections, map);
    _buildWeeklyLogs(DateTime.now(), selections, map);

    setState(() => _loading = false);
  }

  // Pull to refresh trigger reload
  Future<void> _pullToRefresh() => _loadData();

  // Build a DailyLog for a single day
  DailyLog _buildDailyLog(
      DateTime date,
      List<SelectedMeal> selections,
      Map<String, Meal> mealMap,
  ) {
    final day = DateTime(date.year, date.month, date.day);

    double c = 0, p = 0, s = 0, f = 0;
    bool veg = false;

    // Loop through selected meals and sum nutrition for this day
    for (final sel in selections) {
      final selDay = DateTime(sel.date.year, sel.date.month, sel.date.day);
      if (selDay != day) continue; //include only today's meals

      final meal = mealMap[sel.mealId]; //Get meal info
      if (meal == null) continue;

      final n = meal.nutrition;
      c += n.calories;
      p += n.protein;
      s += n.sugar;
      f += n.fat;
      veg = veg || n.vegetables;
    }

    // Return daily nutrition summary
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

  //  Build logs for a week 
  List<DailyLog> _buildWeeklyLogs(
      DateTime endDate,
      List<SelectedMeal> selections,
      Map<String, Meal> mealMap,
  ) {
    final today = DateTime(endDate.year, endDate.month, endDate.day);
    final monday = today.subtract(Duration(days: today.weekday - 1)); // Find Monday

    final out = <DailyLog>[];
    for (int i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      out.add(_buildDailyLog(day, selections, mealMap)); // Add daily summary
    }
    return out;
  }

  //  Build UI 
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
            // Calculate today's nutrition totals from selected meals
            double c = 0, p = 0, s = 0, f = 0;
            bool veg = false;
            for (final meal in selectedMeals) {
              final n = meal.nutrition;
              c += n.calories;
              p += n.protein;
              s += n.sugar;
              f += n.fat;
              veg = veg || n.vegetables;
            }

            final todayLog = DailyLog(
              date: DateTime.now(),
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
                // Header
                HomeHeader(
                  title: 'Nutrition Overview',
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

                // Show Today or Weekly summary
                if (_view == HomeView.today) ...[
                  TodaySummaryCard(log: todayLog),
                  const SizedBox(height: 12),
                  TodayWarningCard(log: todayLog),
                ] else ...[
                  // Weekly summary: recalc from selected meals
                  WeeklySummary(
                    weeklyLogs: _buildWeeklyLogs(
                      DateTime.now(),
                      selectedMeals
                          .map(
                            (meal) => SelectedMeal(
                              id: meal.id + DateTime.now().toIso8601String(),
                              mealId: meal.id,
                              mealTime: MealTime.lunch,
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
