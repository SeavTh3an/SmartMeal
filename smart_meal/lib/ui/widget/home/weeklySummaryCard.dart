
// lib/ui/widget/home/weekly_summary_unified.dart
import 'package:flutter/material.dart';
import '../../../model/dailyLog.dart';
import '../../../model/nutrition.dart';

// If you have Recommendation model, import it:
import '../../../model/recommendation.dart'; 
// If you do NOT have it, uncomment the fallback below:
/*
class Recommendation {
  static const double calories = 2000;
  static const double protein  = 50;
  static const double sugar    = 25;
  static const double fat      = 70;
  static const int    vegetablesServingsPerDay = 3; // servings/day
}
*/

class WeeklySummaryUnifiedCard extends StatelessWidget {
  final List<DailyLog> weeklyLogs;

  const WeeklySummaryUnifiedCard({super.key, required this.weeklyLogs});

  static const Color _kDarkGreen     = Color(0xFF1F3A22);
  static const Color _kStrokeGreen   = Color(0xFF2E7D32);
  static const Color _kBoxLightGreen = Color(0xFFCBF4B1);

  @override
  Widget build(BuildContext context) {
    // Date range label (if you track dates elsewhere, pass them in; here we show generic)
    final dateRangeText = _dateRangeText(weeklyLogs.length);

    // Aggregate weekly totals
    final totals = _WeeklyTotals.fromLogs(weeklyLogs);

    // Weekly targets (daily recommendation ×7)
    final targets = _WeeklyTargets.fromRecommendation(days: 7);

    // Vegetables: using "days with vegetables" vs "target servings"
    // If you track servings, replace vegDays with weekly servings.
    final vegDays = totals.vegDays;
    final vegTargetServings = targets.vegServings; // e.g., 3/day × 7 = 21 servings

    // Status lines
    final calLine = _StatusLine.forValue(
      label: 'Calories',
      total: totals.calories,
      target: targets.calories,
      highIsBad: true,
      unit: 'kcal',
    );
    final protLine = _StatusLine.forValue(
      label: 'Protein',
      total: totals.protein,
      target: targets.protein,
      highIsBad: false,
      unit: 'g',
    );
    final sugarLine = _StatusLine.forValue(
      label: 'Sugar',
      total: totals.sugar,
      target: targets.sugar,
      highIsBad: true,
      unit: 'g',
    );
    final fatLine = _StatusLine.forValue(
      label: 'Fat',
      total: totals.fat,
      target: targets.fat,
      highIsBad: true,
      unit: 'g',
    );
    final vegLine = _VegetableStatusLine(
      label: 'Vegetables',
      actualServingsOrDays: vegDays.toDouble(),
      targetServings: vegTargetServings.toDouble(),
    );

    final suggestions = _buildSuggestions(totals, targets, vegDays);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kBoxLightGreen.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kStrokeGreen, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with date range
          Text(
            'Weekly Nutrition Summary $dateRangeText',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _kDarkGreen,
            ),
          ),

          const SizedBox(height: 12),

          // ===== Upper section: Chart (Calories & Sugar) =====
          SizedBox(
            height: 180,
            child: CustomPaint(
              painter: _WeeklyTrendPainter(weeklyLogs),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              _LegendDot(color: Color(0xFF2E7D32)), // green for calories
              SizedBox(width: 6),
              Text('Calories'),
              SizedBox(width: 16),
              _LegendDot(color: Color(0xFFD32F2F)), // red for sugar
              SizedBox(width: 6),
              Text('Sugar'),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),

          // ===== Lower section: Summary like your screenshot =====
          const SizedBox(height: 12),
          _SummaryRow(line: calLine),
          _SummaryRow(line: protLine),
          _SummaryRow(line: sugarLine),
          _SummaryRow(line: fatLine),
          _SummaryRowVegetable(line: vegLine),

          const SizedBox(height: 12),
          const Divider(height: 1),

          const SizedBox(height: 8),
          const Text(
            'Suggestions:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          ...suggestions.map((t) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('– ', style: TextStyle(fontSize: 16)),
                    Expanded(child: Text(t)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ---------------- helpers ----------------

  String _dateRangeText(int count) {
    // If you track dates, pass and format them. Here, show "(7 days)" or "(N days)"
    return count > 0 ? '(${count} days)' : '(No data)';
  }

  List<String> _buildSuggestions(_WeeklyTotals totals, _WeeklyTargets targets, int vegDays) {
    final tips = <String>[];

    if (totals.sugar > targets.sugar) {
      tips.add('Reduce sugar intake for snacks.');
    }
    if (totals.fat > targets.fat) {
      tips.add('Balance high-fat meals and prefer lean proteins.');
    }
    if (totals.calories > targets.calories) {
      tips.add('Consider smaller portions and light activity.');
    }
    if (vegDays < (targets.vegServings / 3)) { // if target is 3/day, approximate days target
      tips.add('Add more vegetables during lunch/dinner.');
    }
    if (tips.isEmpty) {
      tips.add('Great balance this week — keep it up!');
    }
    return tips;
  }
}

/// Aggregation of a week’s logs
class _WeeklyTotals {
  final double calories;
  final double protein;
  final double sugar;
  final double fat;
  final int vegDays;

  const _WeeklyTotals({
    required this.calories,
    required this.protein,
    required this.sugar,
    required this.fat,
    required this.vegDays,
  });

  factory _WeeklyTotals.fromLogs(List<DailyLog> logs) {
    double cal = 0, prot = 0, sug = 0, f = 0;
    int vegDays = 0;
    for (final d in logs) {
      cal += d.total.calories;
      prot += d.total.protein;
      sug += d.total.sugar;
      f += d.total.fat;
      if (d.total.vegetables) vegDays++;
    }
    return _WeeklyTotals(
      calories: cal,
      protein: prot,
      sugar: sug,
      fat: f,
      vegDays: vegDays,
    );
  }
}

/// Weekly target based on daily Recommendation × days
class _WeeklyTargets {
  final double calories;
  final double protein;
  final double sugar;
  final double fat;
  final int vegServings;

  const _WeeklyTargets({
    required this.calories,
    required this.protein,
    required this.sugar,
    required this.fat,
    required this.vegServings,
  });

  factory _WeeklyTargets.fromRecommendation({required int days}) {
    return _WeeklyTargets(
      calories: Recommendation.calories * days,
      protein: Recommendation.protein * days,
      sugar: Recommendation.sugar * days,
      fat: Recommendation.fat * days,
      vegServings: Recommendation.vegetablesServingsPerDay * days,
    );
  }
}

/// One numeric line status (Calories/Protein/Sugar/Fat)
class _StatusLine {
  final String label;
  final String textLeft;   // e.g., "Calories: 14,500 / 14,000"
  final String textRight;  // e.g., "⚠ Over" | "✅ Good"
  final Color colorRight;  // color for the status textRight

  const _StatusLine({
    required this.label,
    required this.textLeft,
    required this.textRight,
    required this.colorRight,
  });

  static _StatusLine forValue({
    required String label,
    required double total,
    required double target,
    required bool highIsBad,
    required String unit,
  }) {
    final totalStr  = _fmt(total);
    final targetStr = _fmt(target);
    final left = '$label: $totalStr / $targetStr';

    // Decide status
    late String right;
    late Color color;
    if (total > target) {
      // Over target
      right = '⚠ Over';
      color = Colors.red.shade700;
    } else if ((total / target) >= 0.95) {
      // Near target (95%+ of target) – treat as "Good" for protein, "OK" for others
      right = highIsBad ? '✅ OK' : '✅ Good';
      color = Colors.green.shade700;
    } else {
      right = highIsBad ? '✅ Good' : '⚠ Low';
      color = highIsBad ? Colors.green.shade700 : Colors.orange.shade700;
    }

    return _StatusLine(label: label, textLeft: left, textRight: right, colorRight: color);
  }

  static String _fmt(double v) {
    // format with thousands separator and 0/1 decimals
    if (v >= 1000) {
      return v.toStringAsFixed(0); // keep it simple; customize if needed
    }
    return v.toStringAsFixed(1);
  }
}

/// Vegetables line status (servings/days)
class _VegetableStatusLine {
  final String label;
  final String textLeft;   // e.g., "Vegetables: 18 servings / 21 servings"
  final String textRight;  // e.g., "⚠ Low" | "✅ Good"
  final Color colorRight;

  _VegetableStatusLine({
    required this.label,
    required double actualServingsOrDays,
    required double targetServings,
  }) : textLeft = 'Vegetables: ${_fmt(actualServingsOrDays)} servings / ${_fmt(targetServings)} servings',
       // Decide status (low if below target)
       textRight = actualServingsOrDays >= targetServings ? '✅ Good' : '⚠ Low',
       colorRight = actualServingsOrDays >= targetServings
            ? Colors.green.shade700
            : Colors.orange.shade700;

  static String _fmt(double v) => v.toStringAsFixed(0);
}

/// Row renderer for numeric lines
class _SummaryRow extends StatelessWidget {
  final _StatusLine line;
  const _SummaryRow({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              line.textLeft,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            line.textRight,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: line.colorRight),
          ),
        ],
      ),
    );
  }
}

/// Row renderer for vegetables line
class _SummaryRowVegetable extends StatelessWidget {
  final _VegetableStatusLine line;
  const _SummaryRowVegetable({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              line.textLeft,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red, // match your screenshot emphasizing veg in red
              ),
            ),
          ),
          Text(
            line.textRight,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: line.colorRight),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}

/// Embedded chart painter: calories (green) & sugar (red) series
class _WeeklyTrendPainter extends CustomPainter {
  final List<DailyLog> logs;
  _WeeklyTrendPainter(this.logs);

  @override
  void paint(Canvas canvas, Size size) {
    final paintAxis = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;

    final left = 24.0, right = size.width - 8, top = 8.0, bottom = size.height - 24.0;

    canvas.drawLine(Offset(left, bottom), Offset(right, bottom), paintAxis);
    canvas.drawLine(Offset(left, top), Offset(left, bottom), paintAxis);

    if (logs.isEmpty) return;

    final calories = logs.map((d) => d.total.calories).toList();
    final sugar    = logs.map((d) => d.total.sugar).toList();
    final maxVal   = [
      ...calories,
      ...sugar,
      1.0,
    ].reduce((a, b) => a > b ? a : b);

    final count = logs.length;
    final dx = (right - left) / ((count - 1).clamp(1, 99));
    double xAt(int i) => left + i * dx;
    double yFor(double v) => bottom - (v / maxVal) * (bottom - top - 10);

    // Calories path (green)
    final paintCal = Paint()
      ..color = const Color(0xFF2E7D32)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pathCal = Path()..moveTo(xAt(0), yFor(calories[0]));
    for (int i = 1; i < calories.length; i++) {
      pathCal.lineTo(xAt(i), yFor(calories[i]));
    }
    canvas.drawPath(pathCal, paintCal);

    // Sugar path (red)
    final paintSugar = Paint()
      ..color = const Color(0xFFD32F2F)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pathSugar = Path()..moveTo(xAt(0), yFor(sugar[0]));
    for (int i = 1; i < sugar.length; i++) {
      pathSugar.lineTo(xAt(i), yFor(sugar[i]));
    }
    canvas.drawPath(pathSugar, paintSugar);
  }

  @override
  bool shouldRepaint(covariant _WeeklyTrendPainter oldDelegate) => true;
}
