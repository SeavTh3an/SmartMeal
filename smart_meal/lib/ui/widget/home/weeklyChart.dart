import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../model/dailyLog.dart';
import '../../../model/recommendation.dart';
import '../../theme/weekColor.dart';

class WeeklyChart extends StatelessWidget {
  final List<DailyLog> logs;
  const WeeklyChart({super.key, required this.logs});

  static const double _barWidth = 12;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) return const SizedBox();

    // Calculate sensible Y-axis max (covers both targets and highest values)
    final highestProtein = logs.map((e) => e.total.protein).fold<double>(0, (a, b) => a > b ? a : b);
    final highestSugar   = logs.map((e) => e.total.sugar).fold<double>(0, (a, b) => a > b ? a : b);
    final baseMax = [
      highestProtein,
      highestSugar,
      Recommendation.protein,
      Recommendation.sugar,
    ].reduce((a, b) => a > b ? a : b);
    final maxY = baseMax * 1.25;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Legend
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Wrap(
            spacing: 12,
            runSpacing: 6,
            children: const [
              _LegendSwatch(color: WeekColors.protein, label: 'Protein (g)'),
              _LegendSwatch(color: WeekColors.sugar,   label: 'Sugar (g)'),
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
                      final label = _weekdayLabel(d.weekday);
                      final color = WeekColors.weekdayTint(d.weekday);
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
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
                    y: Recommendation.protein,
                    color: WeekColors.protein,
                    strokeWidth: 2,
                    dashArray: [6, 6],
                    label: HorizontalLineLabel(
                      show: true,
                      labelResolver: (_) => 'Protein target (${Recommendation.protein.toStringAsFixed(0)}g)',
                      style: const TextStyle(color: WeekColors.protein),
                    ),
                  ),
                  HorizontalLine(
                    y: Recommendation.sugar,
                    color: WeekColors.sugar,
                    strokeWidth: 2,
                    dashArray: [6, 6],
                    label: HorizontalLineLabel(
                      show: true,
                      labelResolver: (_) => 'Sugar limit (${Recommendation.sugar.toStringAsFixed(0)}g)',
                      style: const TextStyle(color: WeekColors.sugar),
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
    // Grouped bars: two rods per day (protein + sugar)
    return logs.asMap().entries.map((entry) {
      final index = entry.key;
      final n = entry.value.total;
      return BarChartGroupData(
        x: index,
        barsSpace: 8, // spacing between rods
        barRods: [
          BarChartRodData(
            toY: n.protein,
            color: WeekColors.protein,
            width: _barWidth,
            borderRadius: BorderRadius.circular(6),
          ),
          BarChartRodData(
            toY: n.sugar,
            color: WeekColors.sugar,
            width: _barWidth,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();
  }

  String _weekdayLabel(int w) => const ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][w - 1];
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
