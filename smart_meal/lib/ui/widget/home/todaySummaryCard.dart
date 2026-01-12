import 'package:flutter/material.dart';
import '../../../model/dailyLog.dart';
import '../../../model/recommendation.dart';
import '../../widget/mealDetail/nutritionRow.dart';
import 'sectionCard.dart';

class TodaySummaryCard extends StatelessWidget {
  final DailyLog log;

  const TodaySummaryCard({super.key, required this.log});

  // Decide Low/Medium/High vs recommendation
  String _level(double value, double recMax) {
    if (value >= recMax) return 'High';
    if (value >= 0.6 * recMax) return 'Medium';
    return 'Low';
  }

  // A simple overall status text
  String _status(DailyLog log) {
    if (log.isSugarHigh || log.isFatHigh || log.isCaloriesHigh) return 'Warning';
    // If near thresholds (you can refine)
    final near =
        (log.total.calories >= 0.8 * Recommendation.calories) ||
        (log.total.sugar    >= 0.8 * Recommendation.sugar)    ||
        (log.total.fat      >= 0.8 * Recommendation.fat);
    if (near) return 'Moderate';
    return 'Healthy';
  }

  @override
  Widget build(BuildContext context) {
    final status = _status(log);

    return SectionCard(
      title: "Today's Nutrition Summary",
      trailing: _StatusChip(text: status),
      child: Column(
        children: [
          NutritionRow(
            label: 'Calories',
            levelText: _level(log.total.calories, Recommendation.calories),
            icon: Icons.local_fire_department,
          ),
          const Divider(height: 16),
          NutritionRow(
            label: 'Protein',
            levelText: _level(log.total.protein, Recommendation.protein),
            icon: Icons.fitness_center,
          ),
          const Divider(height: 16),
          NutritionRow(
            label: 'Sugar',
            levelText: _level(log.total.sugar, Recommendation.sugar),
            icon: Icons.cake,
          ),
          const Divider(height: 16),
          NutritionRow(
            label: 'Fats',
            levelText: _level(log.total.fat, Recommendation.fat),
            icon: Icons.opacity,
          ),
          const Divider(height: 16),
          NutritionRow(
            label: 'Vegetable',
            icon: Icons.eco,
            booleanValue: log.total.vegetables,
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  const _StatusChip({required this.text});

  Color get _color {
    switch (text) {
      case 'Healthy':  return const Color(0xFF2E7D32);
      case 'Moderate': return const Color(0xFFFFA000);
      case 'Warning':  return const Color(0xFFD32F2F);
      default:         return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(20)),
      child: Text(
        text,
        style: TextStyle(
          color: c.computeLuminance() > 0.6 ? Colors.black : Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
