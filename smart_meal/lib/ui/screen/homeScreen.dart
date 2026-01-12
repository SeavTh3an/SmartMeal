import 'package:flutter/material.dart';
import '../../model/meal.dart';
import '../../model/nutrition.dart';
import '../../model/dailyLog.dart';
import '../widget/header/homeHeader.dart';
import '../widget/topNavigation.dart';
import '../widget/home/todaySummaryCard.dart';
import '../widget/home/todayWarningCard.dart';
import '../widget/home/weeklySummaryCard.dart';
import 'mainScreen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _openTopMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => TopMenuSheet(
        currentIndex: 0,
        onSelected: (index) {
          MainScreen.of(context).changeTab(index);
        },
      ),
    );
  }

  DailyLog _buildTodayLog(List<Meal> meals) {
    double cal = 0, protein = 0, sugar = 0, fat = 0;
    bool veg = false;

    for (final meal in meals) {
      cal += meal.nutrition.calories;
      protein += meal.nutrition.protein;
      sugar += meal.nutrition.sugar;
      fat += meal.nutrition.fat;
      veg = veg || meal.nutrition.vegetables;
    }

    return DailyLog(
      Nutrition(
        calories: cal,
        protein: protein,
        sugar: sugar,
        fat: fat,
        vegetables: veg,
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return "Good morning, here’s your health summary";
    if (hour >= 12 && hour < 18) return "Good afternoon, here’s your health summary";
    return "Good evening, here’s your health summary";
  }

  /// TEMP: build weekly logs. Replace this with your real 7-day aggregation
  /// when you have daily data persisted with dates.
  List<DailyLog> _buildWeeklyLogs(DailyLog todayLog) {
    // For now, duplicate today across 7 days so the card renders.
    return List<DailyLog>.generate(7, (_) => todayLog);
  }

  @override
  Widget build(BuildContext context) {
    final selectedMeals = MainScreen.of(context).selectedMealsList;
    final todayLog = _buildTodayLog(selectedMeals);
    final weeklyLogs = _buildWeeklyLogs(todayLog); // TODO: replace with real weekly data

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header (unchanged)
          HomeHeader(
            title: 'What should you\ncook today?',
            imagePath: 'assets/image/western_img/salad_header.png',
            onMenuTap: _openTopMenu,
          ),

          // Tabs controller (Today | Weekly)
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  // Greeting section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _greeting(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F3A22),
                        ),
                      ),
                    ),
                  ),

                  // Segmented tabs (Today / Weekly)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black87,
                      indicator: BoxDecoration(
                        color: const Color(0xFF1F3A22), // dark green like Add screen
                        borderRadius: BorderRadius.circular(24),
                      ),
                      tabs: const [
                        Tab(text: 'Today'),
                        Tab(text: 'Weekly'),
                      ],
                    ),
                  ),

                  // Tab content
                  Expanded(
                    child: TabBarView(
                      children: [
                        // === Today tab ===
                        ListView(
                          padding: const EdgeInsets.only(bottom: 24),
                          children: [
                            const SizedBox(height: 12),
                            TodaySummaryCard(log: todayLog),
                            TodayWarningCard(log: todayLog),
                          ],
                        ),

                        // === Weekly tab ===
                        ListView(
                          padding: const EdgeInsets.only(bottom: 24),
                          children: [
                            const SizedBox(height: 16),
                            WeeklySummaryCard(weeklyLogs: weeklyLogs),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
