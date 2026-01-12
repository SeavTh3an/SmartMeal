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
      warnings.add("High sugar intake today");
      tips.add("Reduce sugary drinks and desserts.");
    }
    if (log.isFatHigh) {
      warnings.add("Fat intake is above limit");
      tips.add("Choose lean proteins and cook with less oil.");
    }
    if (log.isCaloriesHigh) {
      warnings.add("Calories exceeded recommended amount");
      tips.add("Add a light walk and reduce portions in dinner.");
    }
    if (warnings.isEmpty) {
      tips.add("Great job! Keep a balanced plate and hydrate well.");
    }

    return SectionCard(
      title: "Today's Warnings & Suggestions",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warnings
          ...warnings.map((w) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('⚠ ', style: TextStyle(fontSize: 16)),
                    Expanded(child: Text('')),
                  ],
                ),
              )).toList(),
          // Render actual text inline (replace blank above)
          ...warnings.map((w) => Padding(
                padding: const EdgeInsets.only(left: 22, bottom: 4),
                child: Text(w),
              )),

          // Suggestions
          const SizedBox(height: 8),
          ...tips.map((t) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: const [
                    Text('✅ ', style: TextStyle(fontSize: 16)),
                    Expanded(child: Text('')),
                  ],
                ),
              )).toList(),
          ...tips.map((t) => Padding(
                padding: const EdgeInsets.only(left: 22, bottom: 3),
                child: Text(t),
              )),
        ],
      ),
    );
  }
}
