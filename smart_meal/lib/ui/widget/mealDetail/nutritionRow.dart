import 'package:flutter/material.dart';

class NutritionRow extends StatelessWidget {
  final String label;
  final String? levelText;    
  final IconData icon;
  final bool? booleanValue;   

  const NutritionRow({
    super.key,
    required this.label,
    this.levelText,
    required this.icon,
    this.booleanValue,
  });

  // Nutrients where HIGH is considered bad
  static const Set<String> _highIsBad = {
    'calories',
    'sugar',
    'fats',
  };


  // Color mapping for levels for "high is BAD"
  Color _colorForLevelHighBad(String? level) {
    switch ((level ?? '').toLowerCase().trim()) {
      case 'high':
        return const Color(0xFFD32F2F); 
      case 'medium':
        return const Color(0xFFFFA000); 
      case 'low':
        return const Color(0xFF2E7D32); 
      default:
        return Colors.grey;
    }
  }

  // Color mapping for levels for "high is GOOD"
  Color _colorForLevelHighGood(String? level) {
    switch ((level ?? '').toLowerCase().trim()) {
      case 'high':
        return const Color(0xFF2E7D32); // green
      case 'medium':
        return const Color(0xFFFFA000); // orange/amber
      case 'low':
        return const Color(0xFFD32F2F); // red
      default:
        return Colors.grey;
    }
  }

  // Pick icon color per metric (optional aesthetic)
  Color _iconTintForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'calories':
        return const Color(0xFFEF6C00); // orange
      case 'protein':
        return const Color(0xFF00796B); // teal
      case 'sugar':
        return const Color(0xFFC2185B); // pink/red
      case 'fats':
        return const Color(0xFFFFA000); // amber
      case 'vegetable':
        return const Color(0xFF2E7D32); // green
      default:
        return const Color(0xFF1F3A22); // dark green default
    }
  }

  @override
  Widget build(BuildContext context) {
    final String key = label.toLowerCase().trim();

    // Boolean row (Vegetable Yes/No)
    if (booleanValue != null) {
      final bool value = booleanValue!;
      final Color pill = value ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F);
      final IconData mark = value ? Icons.check : Icons.close;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: _iconTintForLabel(key)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: pill, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Icon(mark, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    value ? 'Yes' : 'No',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Level row (Calories, Protein, Sugar, Fats...)
    final Color badgeColor = _highIsBad.contains(key)
        ? _colorForLevelHighBad(levelText)
        : _colorForLevelHighGood(levelText);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: _iconTintForLabel(key)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(20)),
            child: Text(
              levelText ?? '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: badgeColor.computeLuminance() > 0.6 ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
