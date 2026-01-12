import 'package:flutter/material.dart';
import '../../../model/dailyLog.dart';
import '../../../model/recommendation.dart';
import 'sectionCard.dart';
import 'nutritionStatRow.dart';

class TodaySummaryCard extends StatelessWidget {
  final DailyLog log;
  const TodaySummaryCard({super.key, required this.log});

  bool get _isEmpty =>
      log.total.calories == 0 &&
      log.total.protein == 0 &&
      log.total.sugar == 0 &&
      log.total.fat == 0;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: "Today's Nutrition Summary",
      trailing: _StatusChip(text: log.status),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'No meals logged today yet.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          NutritionStatRow(
            label: 'Calories',
            icon: Icons.local_fire_department,
            value: log.total.calories,
            unit: 'kcal',
            target: Recommendation.calories,
          ),
          const Divider(height: 16),
          NutritionStatRow(
            label: 'Protein',
            icon: Icons.fitness_center,
            value: log.total.protein,
            unit: 'g',
            target: Recommendation.protein,
          ),
          const Divider(height: 16),
          NutritionStatRow(
            label: 'Sugar',
            icon: Icons.cake,
            value: log.total.sugar,
            unit: 'g',
            target: Recommendation.sugar,
          ),
          const Divider(height: 16),
          NutritionStatRow(
            label: 'Fat',
            icon: Icons.opacity,
            value: log.total.fat,
            unit: 'g',
            target: Recommendation.fat,
          ),
          const Divider(height: 16),
          Row(
            children: [
              const Icon(Icons.eco, color: Color(0xFF1F3A22)),
              const SizedBox(width: 12),
              Expanded(child: Text('Vegetables', style: Theme.of(context).textTheme.bodyMedium)),
              Icon(
                log.total.vegetables ? Icons.check_circle : Icons.cancel,
                color: log.total.vegetables ? Colors.green : Colors.redAccent,
              ),
            ],
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
      case 'Healthy': return const Color(0xFF2E7D32);
      case 'Moderate': return const Color(0xFFFFA000);
      case 'Warning': return const Color(0xFFD32F2F);
      default: return Colors.grey;
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
