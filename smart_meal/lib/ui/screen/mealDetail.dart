import 'package:flutter/material.dart';

import '../../model/meal.dart';
import '../../model/selectedMeal.dart';
import '../widget/mealDetail/mealDetailWidget.dart';
import '../widget/mealDetail/dialog.dart';
import 'mainScreen.dart';

class MealDetailScreen extends StatelessWidget {
  final Meal meal;
  final bool isSelected;

  const MealDetailScreen({
    super.key,
    required this.meal,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MealDetailWidget(
        meal: meal,
        isSelected: isSelected,
        onBack: () => Navigator.pop(context),
        onCancel: () => Navigator.pop(context),
        onToggleSelected: (nextSelected) async {
          if (nextSelected) {
            // Open custom meal time dialog
            final List<MealTime>? picked = await showDialog<List<MealTime>>(
              context: context,
              barrierDismissible: false,
              builder: (_) => const MealTimeDialog(),
            );

            if (picked != null && picked.isNotEmpty) {
              // return the picked times to the caller so it can persist from the parent context
              Navigator.pop(context, picked);
            }
          } else {
            MainScreen.of(context).removeSelectedMeal(meal);
            Navigator.pop(context, 'removed');
          }
        },
      ),
    );
  }
}
