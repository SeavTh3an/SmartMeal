import 'package:flutter/material.dart';
import '../../../model/dailyLog.dart';
import '../../../model/recommendation.dart';
import 'weeklyChart.dart';
import 'sectionCard.dart';
import '../../theme/weekColor.dart';

class WeeklySummary extends StatefulWidget {
  final List<DailyLog> weeklyLogs;
  final bool showChart; // keep chart + overview + warnings + suggestions
  const WeeklySummary({super.key, required this.weeklyLogs, this.showChart = true});

  @override
  State<WeeklySummary> createState() => _WeeklySummaryState();
}

class _WeeklySummaryState extends State<WeeklySummary> {
  bool _showDaily = false;

  @override
  Widget build(BuildContext context) {
    final logs = widget.weeklyLogs;
    if (logs.isEmpty) {
      return SectionCard(
        title: 'Weekly Overview',
        child: const Text('No data for this week yet. Log some meals to see insights.'),
      );
    }

    // Totals (Mon–Sun)
    double totProtein = 0, totSugar = 0, totFat = 0, totCalories = 0;
    int vegDays = 0;
    for (final d in logs) {
      totProtein += d.total.protein;
      totSugar += d.total.sugar;
      totFat += d.total.fat;
      totCalories += d.total.calories;
      if (d.total.vegetables) vegDays++;
    }

    // Warnings
    final overSugarDays = logs.where((d) => d.total.sugar > Recommendation.sugar).length;
    final overFatDays   = logs.where((d) => d.total.fat   > Recommendation.fat).length;

    // Suggestions
    final Set<String> suggestions = {
      ...logs.suggestions(),
      if (vegDays < 3) 'Add more vegetables during lunch',
      if (overFatDays > 0) 'Balance high-fat meals',
    };

    return Column(
      children: [
        if (widget.showChart) ...[
          WeeklyChart(logs: logs), // chart uses WeekColors too
          const SizedBox(height: 12),
        ],

        // Weekly Overview (Totals only)
        SectionCard(
          title: 'Weekly Overview',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Totals tiles (icon & label colored by nutrient color)
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _statTile(
                    icon: Icons.local_fire_department,
                    label: 'Total Calories',
                    valueText: '${totCalories.toStringAsFixed(0)} kcal',
                    color: WeekColors.calories,
                  ),
                  _statTile(
                    icon: Icons.fitness_center,
                    label: 'Total Protein',
                    valueText: '${totProtein.toStringAsFixed(0)} g',
                    color: WeekColors.protein,
                  ),
                  _statTile(
                    icon: Icons.opacity,
                    label: 'Total Fat',
                    valueText: '${totFat.toStringAsFixed(0)} g',
                    color: WeekColors.fat,
                  ),
                  _statTile(
                    icon: Icons.cake,
                    label: 'Total Sugar',
                    valueText: '${totSugar.toStringAsFixed(0)} g',
                    color: WeekColors.sugar,
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Warnings & Suggestions (always shown)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (overSugarDays > 0)
                    _pillChip(
                      text: 'Sugar over limit on $overSugarDays day(s)',
                      color: WeekColors.sugar,
                      icon: Icons.warning_amber_rounded,
                    ),
                  if (overFatDays > 0)
                    _pillChip(
                      text: 'Fat over limit on $overFatDays day(s)',
                      color: WeekColors.fat,
                      icon: Icons.warning_amber_rounded,
                    ),
                  if (overSugarDays == 0 && overFatDays == 0)
                    _pillChip(
                      text: 'Great balance this week',
                      color: WeekColors.calories,
                      icon: Icons.check_circle,
                    ),
                ],
              ),

              const SizedBox(height: 12),
              _suggestionsList(suggestions.toList()),

              const SizedBox(height: 12),

              // Toggle for daily breakdown
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => setState(() => _showDaily = !_showDaily),
                  icon: Icon(_showDaily ? Icons.expand_less : Icons.expand_more),
                  label: Text(_showDaily ? 'Hide daily breakdown' : 'Show daily breakdown'),
                ),
              ),

              // Collapsible daily lines:
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _showDaily
                    ? Padding(
                        key: const ValueKey('daily-breakdown'),
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          children: logs.map((d) {
                            final wdIndex = d.date.weekday; // Mon=1..Sun=7
                            final wdLabel = const ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][wdIndex - 1];
                            final dayTint = WeekColors.weekdayTint(wdIndex);

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFE0E0E0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Day name pill (no calendar icon), tinted by weekday color
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: dayTint.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      wdLabel,
                                      style: TextStyle(color: dayTint, fontWeight: FontWeight.w700),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // Nutrients (icon + text tinted by nutrient colors)
                                  Expanded(
                                    child: Wrap(
                                      spacing: 12,
                                      runSpacing: 6,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        _nutItem(Icons.local_fire_department, '${d.total.calories.toStringAsFixed(0)} kcal', WeekColors.calories),
                                        _nutItem(Icons.fitness_center,        '${d.total.protein.toStringAsFixed(0)} g P',   WeekColors.protein),
                                        _nutItem(Icons.opacity,               '${d.total.fat.toStringAsFixed(0)} g F',       WeekColors.fat),
                                        _nutItem(Icons.cake,                  '${d.total.sugar.toStringAsFixed(0)} g S',     WeekColors.sugar),
                                        if (d.total.vegetables)
                                          _nutItem(Icons.eco,                 'Veg ✓',                                        WeekColors.calories),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- UI Helpers ---

  Widget _statTile({
    required IconData icon,
    required String label,
    required String valueText,
    required Color color,
  }) {
    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label tinted same as icon (nutrient color)
                Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(valueText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: WeekColors.textDark,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pillChip({required String text, required Color color, required IconData icon}) {
    final onColor = color.computeLuminance() > 0.6 ? Colors.black : Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: onColor),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: onColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _suggestionsList(List<String> tips) {
    if (tips.isEmpty) {
      return const Text('No suggestions this week. Keep it up!');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tips.map((t) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(t)),
        ],
      )).toList(),
    );
  }

  Widget _nutItem(IconData icon, String text, Color tint) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: tint),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: tint)),
      ],
    );
  }
}
