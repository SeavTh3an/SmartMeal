import 'package:flutter/material.dart';
import '../../../model/dailyLog.dart';
import 'sectionCard.dart';

class TodayWarningCard extends StatelessWidget {
  final DailyLog log;

  const TodayWarningCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final warnings = <String>[];
    final tips = <String>[];

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

    if (warnings.isEmpty) {
      tips.add('Great job today! Keep a balanced diet.');
    }

    return SectionCard(
      title: "Today's Warnings & Suggestions",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...warnings.map((w) => Text('⚠ $w')),
          const SizedBox(height: 8),
          ...tips.map((t) => Text('✅ $t')),
        ],
      ),
    );
  }
}
