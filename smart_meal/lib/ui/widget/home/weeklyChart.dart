import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../model/dailyLog.dart';

class WeeklyChart extends StatelessWidget {
  final List<DailyLog> logs;
  const WeeklyChart({super.key, required this.logs});

  static const double recommendedProtein = 50;
  static const double recommendedSugar = 25;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) return const SizedBox();
    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _maxY(),
          titlesData: FlTitlesData(show: true),
          barGroups: _barGroups(),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: recommendedProtein + recommendedSugar,
                color: Colors.orange,
                strokeWidth: 2,
                dashArray: [6, 6],
                label: HorizontalLineLabel(show: true, labelResolver: (_) => 'Recommended max'),
              ),
            ],
          ),
        ),
        swapAnimationDuration: const Duration(milliseconds: 600), // here
        swapAnimationCurve: Curves.easeInOut,
      ),
    );
  }

  double _maxY() {
    return logs.map((e) => e.total.protein + e.total.sugar).reduce((a, b) => a > b ? a : b) * 1.3;
  }

  List<BarChartGroupData> _barGroups() {
    return logs.asMap().entries.map((entry) {
      final index = entry.key;
      final nutrition = entry.value.total;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: nutrition.protein + nutrition.sugar,
            rodStackItems: [
              BarChartRodStackItem(0, nutrition.protein, Colors.green),
              BarChartRodStackItem(nutrition.protein, nutrition.protein + nutrition.sugar, Colors.red),
            ],
            width: 18,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();
  }
}
