import 'package:flutter/material.dart';

class WeekColors {
  static const Map<int, Color> weekday = {
    1: Color(0xFF2E7D32), // Mon
    2: Color(0xFF1976D2), // Tue
    3: Color(0xFFFFA000), // Wed
    4: Color(0xFF8E24AA), // Thu
    5: Color(0xFF00897B), // Fri
    6: Color(0xFF5C6BC0), // Sat
    7: Color(0xFFD32F2F), // Sun
  };

  // Nutrient colors
  static const Color calories = Color(0xFF2E7D32); 
  static const Color protein  = Colors.green;
  static const Color fat      = Colors.blue;
  static const Color sugar    = Colors.red;

  static const Color textDark = Color(0xFF1F3A22);

  static Color weekdayTint(int weekday) =>
      weekday >= 1 && weekday <= 7 ? WeekColors.weekday[weekday]! : textDark;
}
