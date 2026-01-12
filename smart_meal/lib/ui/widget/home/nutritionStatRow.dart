import 'package:flutter/material.dart';

class NutritionStatRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final double value;
  final String unit;           // 'kcal' or 'g'
  final double? target;        // optional daily recommendation

  const NutritionStatRow({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.unit,
    this.target,
  });

  Color _colorByPct(double pct) {
    if (pct <= 0.9) return const Color(0xFF2E7D32); 
    if (pct <= 1.1) return const Color(0xFFFFA000); 
    return const Color(0xFFD32F2F);                  
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = (target == null || target == 0) ? null : (value / target!).clamp(0.0, 1.5);
    final color = pct == null ? const Color(0xFF1F3A22) : _colorByPct(pct);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF1F3A22)),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
            Text(
              target != null
                  ? '${value.toStringAsFixed(0)} $unit / ${target!.toStringAsFixed(0)} $unit'
                  : '${value.toStringAsFixed(0)} $unit',
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            if (pct != null) ...[
              const SizedBox(width: 8),
              Text('(${(pct * 100).toStringAsFixed(0)}%)',
                  style: theme.textTheme.bodySmall!.copyWith(color: color)),
            ],
          ],
        ),
        if (pct != null) ...[
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct > 1.0 ? 1.0 : pct,
              minHeight: 6,
              backgroundColor: Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ],
    );
  }
}
