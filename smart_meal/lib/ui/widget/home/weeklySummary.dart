import 'package:flutter/material.dart';
import '../../../model/dailyLog.dart';
import '../../../model/recommendation.dart';
import 'weeklyChart.dart';
import 'sectionCard.dart';

class WeeklySummary extends StatefulWidget {
  final List<DailyLog> weeklyLogs;
  const WeeklySummary({super.key, required this.weeklyLogs});

  @override
  State<WeeklySummary> createState() => _WeeklySummaryState();
}

class _WeeklySummaryState extends State<WeeklySummary> {
  bool _showDaily = false;

  @override
  Widget build(BuildContext context) {
    final logs = widget.weeklyLogs;
    final days = logs.length;

    double totProtein = 0, totSugar = 0, totFat = 0, totCalories = 0;
    for (final d in logs) {
      totProtein += d.total.protein;
      totSugar += d.total.sugar;
      totFat += d.total.fat;
      totCalories += d.total.calories;
    }
    final avgProtein = days == 0 ? 0 : totProtein / days;
    final avgSugar   = days == 0 ? 0 : totSugar   / days;
    final avgFat     = days == 0 ? 0 : totFat     / days;
    final avgCal     = days == 0 ? 0 : totCalories/ days;

    final overSugarDays = logs.where((d) => d.total.sugar > Recommendation.sugar).length;

    return Column(
      children: [
        WeeklyChart(logs: logs), // Sugar + Protein only
        const SizedBox(height: 12),
        SectionCard(
          title: 'Weekly Overview',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _kv('Total (7 days)',
                  '${totCalories.toStringAsFixed(0)} kcal | '
                  '${totProtein.toStringAsFixed(0)} g protein | '
                  '${totFat.toStringAsFixed(0)} g fat | '
                  '${totSugar.toStringAsFixed(0)} g sugar'),
              const SizedBox(height: 8),
              _kv('Average per day',
                  '${avgCal.toStringAsFixed(0)} kcal | '
                  '${avgProtein.toStringAsFixed(0)} g protein | '
                  '${avgFat.toStringAsFixed(0)} g fat | '
                  '${avgSugar.toStringAsFixed(0)} g sugar'),
              const SizedBox(height: 8),
              if (overSugarDays > 0)
                Text('⚠ Sugar over limit on $overSugarDays day(s)'),
              if (overSugarDays == 0)
                const Text('✅ Sugar within limit this week'),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => setState(() => _showDaily = !_showDaily),
                  icon: Icon(_showDaily ? Icons.expand_less : Icons.expand_more),
                  label: Text(_showDaily ? 'Hide daily breakdown' : 'Show daily breakdown'),
                ),
              ),
              if (_showDaily) ...[
                const SizedBox(height: 8),
                Column(
                  children: logs.map((d) {
                    final wd = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][d.date.weekday - 1];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Text(wd, style: const TextStyle(fontWeight: FontWeight.w600)),
                          const Spacer(),
                          Text('${d.total.calories.toStringAsFixed(0)} kcal, '
                               '${d.total.protein.toStringAsFixed(0)}g P, '
                               '${d.total.fat.toStringAsFixed(0)}g F, '
                               '${d.total.sugar.toStringAsFixed(0)}g S'),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _kv(String k, String v) {
    return Row(
      children: [
        Text(k, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Spacer(),
        Flexible(child: Text(v, textAlign: TextAlign.right)),
      ],
    );
  }
}
