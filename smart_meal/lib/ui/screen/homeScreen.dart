import 'package:flutter/material.dart';

import '../../model/dailyLog.dart';
import '../../model/nutrition.dart'; 
import '../widget/home/todaySummaryCard.dart';
import '../widget/home/todayWarningCard.dart';
import '../widget/home/weeklySummary.dart';
import '../widget/header/homeHeader.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ===== Mock data (replace later with SharedPreferences) =====
    final todayLog = DailyLog(
      date: DateTime.now(),
      total: Nutrition(
        calories: 1850,
        protein: 60,
        sugar: 30,
        fat: 65,
        vegetables: true,
      ),
    );

    final weeklyLogs = List.generate(7, (i) => todayLog);

    return Scaffold(
      body: ListView(
        children: [
          HomeHeader(
            title: 'Your Nutrition Overview',
            imagePath: 'assets/image/western_img/salad_header.png',
          ),

          const SizedBox(height: 12),
          TodaySummaryCard(log: todayLog),

          const SizedBox(height: 12),

          TodayWarningCard(log: todayLog),

          const SizedBox(height: 12),

          WeeklySummary(weeklyLogs: weeklyLogs),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
