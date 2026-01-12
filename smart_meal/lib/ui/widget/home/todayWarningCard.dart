import 'package:flutter/material.dart';
import '../../../model/dailyLog.dart';
import 'sectionCard.dart';
import '../../../model/recommendation.dart';

class TodayWarningCard extends StatelessWidget {
  final DailyLog log;

  const TodayWarningCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final warnings = <String>[];
    final tips = <String>[];
    // Over-limit checks
    if (log.isSugarHigh) {
      warnings.add('High sugar intake');
      tips.add('Reduce sweet drinks and desserts.');
    }
    if (log.isFatHigh) {
      warnings.add('High fat intake');
      tips.add('Choose lean proteins and less oil.');
    }
    if (log.isCaloriesHigh) {
      warnings.add('Calories exceeded');
      tips.add('Consider lighter dinner portions.');
    }
    // Near-limit nudges
    final nearSugar = log.total.sugar >= 0.9 * Recommendation.sugar;
    final nearFat = log.total.fat >= 0.9 * Recommendation.fat;

    if (warnings.isEmpty) {
      if (nearSugar) tips.add('Sugar near limit—prefer whole fruits over sweets.');
      if (nearFat) tips.add('Fat near limit—favor grilling/steaming today.');
    }

    if (warnings.isEmpty && tips.isEmpty) {
      tips.add('Great job today! Keep a balanced diet.');
    }

    return SectionCard(
      title: "Today's Warnings & Suggestions",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...warnings.map((w) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: const [
                    Icon(Icons.warning, color: Color(0xFFD32F2F), size: 18),
                    SizedBox(width: 6),
                  ],
                ),
              )),
          ...warnings.map((w) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('⚠ $w',
                    style: const TextStyle(color: Color(0xFFD32F2F))),
              )),
          const SizedBox(height: 8),
          ...tips.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('✅ $t',
                    style: const TextStyle(color: Color(0xFF1F3A22))),
              )),
        ],
      ),
    );
  }
}
