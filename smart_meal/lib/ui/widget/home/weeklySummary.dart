import 'package:flutter/material.dart';
import '../../../model/dailyLog.dart';
import 'weeklyChart.dart';
import 'todaySummaryCard.dart';

class WeeklySummary extends StatelessWidget {
  final List<DailyLog> weeklyLogs;
  const WeeklySummary({super.key, required this.weeklyLogs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeeklyChart(logs: weeklyLogs), // stacked bar chart
        const SizedBox(height: 12),
        // Optional: summary for each nutrition over the week
        Column(
          children: weeklyLogs.map((log) {
            return TodaySummaryCard(log: log); // reuse card for each day
          }).toList(),
        ),
      ],
    );
  }
}
