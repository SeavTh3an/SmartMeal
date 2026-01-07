import 'package:flutter/material.dart';

class NutritionRow extends StatelessWidget {
  final String label;
  final String? level; 
  final IconData icon;
  final bool?
  booleanValue; 

  const NutritionRow({
    super.key,
    required this.label,
    this.level,
    required this.icon,
    this.booleanValue,
  });

  LinearGradient _gradientForLabel(String label, {bool positive = true}) {
    switch (label.toLowerCase()) {
      case 'calories':
        return const LinearGradient(
          colors: [Color(0xFFFFB357), Color(0xFFFF7043)],
        );
      case 'protein':
        return const LinearGradient(
          colors: [Color(0xFF7FB3FF), Color(0xFF4A90E2)],
        );
      case 'sugar':
        return const LinearGradient(
          colors: [Color(0xFFF19BFF), Color(0xFFBB6BD9)],
        );
      case 'fats':
        return const LinearGradient(
          colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
        );
      case 'vegetable':
        return positive
            ? const LinearGradient(
                colors: [Color(0xFFB8E986), Color(0xFF6FA55A)],
              )
            : const LinearGradient(
                colors: [Color(0xFFF28B82), Color(0xFFD32F2F)],
              );
      default:
        return const LinearGradient(
          colors: [Color(0xFFB8E986), Color(0xFF6FA55A)],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (booleanValue != null) {
      final bool contains = booleanValue!;
      final gradient = _gradientForLabel('vegetable', positive: contains);
      final IconData mark = contains ? Icons.check : Icons.close;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: gradient,
                shape: BoxShape.circle,
              ),
              child: Center(child: Icon(icon, size: 20, color: Colors.white)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: contains ? Color(0xFF4CAF50) : Color(0xFFEF5350),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(mark, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    contains ? 'Contains' : "Doesn't contain",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Default: show level + progress bar
    Color barColor;
    double progressValue;

    switch (level) {
      case "High":
        barColor = Colors.green;
        progressValue = 0.9;
        break;
      case "Medium":
        barColor = Colors.orange;
        progressValue = 0.6;
        break;
      default:
        barColor = Colors.red;
        progressValue = 0.3;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          /// MAIN ROW
          Row(
            children: [
              /// ICON (colorful)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: _gradientForLabel(label),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Icon(icon, size: 20, color: Colors.white)),
              ),

              const SizedBox(width: 12),

              /// LABEL
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 16)),
              ),

              /// LEVEL BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  level ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: barColor.computeLuminance() > 0.6
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// PROGRESS BAR
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ),
    );
  }
}
