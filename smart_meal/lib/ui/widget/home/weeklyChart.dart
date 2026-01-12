import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../model/dailyLog.dart';
import '../../../model/recommendation.dart';

class WeeklyChart extends StatelessWidget {
  final List<DailyLog> logs;
  const WeeklyChart({super.key, required this.logs});

  static const double _barWidth = 18;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) return const SizedBox();

    // Recommended composite grams for chart (protein + sugar only)
    final recommendedTotal = Recommendation.protein + Recommendation.sugar;

    final highestTotal = logs
        .map((e) => e.total.protein + e.total.sugar)
        .fold<double>(0, (a, b) => a > b ? a : b);

    final maxY = (highestTotal > recommendedTotal ? highestTotal : recommendedTotal) * 1.25;

    return Column(
      children: [
        // Legend
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Wrap(
            spacing: 12,
            runSpacing: 6,
            children: const [
              _LegendSwatch(color: Colors.green, label: 'Protein (g)'),
              _LegendSwatch(color: Colors.red, label: 'Sugar (g)'),
            ],
          ),
        ),
        SizedBox(
          height: 260,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barGroups: _barGroups(),
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= logs.length) return const SizedBox.shrink();
                      final d = logs[i].date;
                      final label = _weekday(d.weekday);
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(label),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
                  ),
                ),
              ),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: recommendedTotal,
                    color: Colors.orange,
                    strokeWidth: 2,
                    dashArray: [6, 6],
                    label: HorizontalLineLabel(
                      show: true,
                      labelResolver: (_) => 'Recommended total (g)',
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
            swapAnimationDuration: const Duration(milliseconds: 600),
            swapAnimationCurve: Curves.easeInOut,
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _barGroups() {
    return logs.asMap().entries.map((entry) {
      final index = entry.key;
      final n = entry.value.total;
      final protein = n.protein;
      final sugar = n.sugar;
      final sum = protein + sugar;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: sum,
            rodStackItems: [
              BarChartRodStackItem(0, protein, Colors.green),
              BarChartRodStackItem(protein, sum, Colors.red),
            ],
            width: _barWidth,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();
  }

  String _weekday(int w) => const ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][w - 1];
}

class _LegendSwatch extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendSwatch({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
