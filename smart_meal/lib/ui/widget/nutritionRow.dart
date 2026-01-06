import 'package:flutter/material.dart';

class NutritionRow extends StatelessWidget {
  final String label;
  final String level;
  final IconData icon;

  const NutritionRow({
    super.key,
    required this.label,
    required this.level,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          /// MAIN ROW
          Row(
            children: [
              /// ICON
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: Colors.black87),
              ),

              const SizedBox(width: 12),

              /// LABEL
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              /// LEVEL BADGE
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  level,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

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
