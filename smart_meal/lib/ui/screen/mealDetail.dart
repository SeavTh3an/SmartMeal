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
            // Show dialog pre-filled with current selected meal times for this meal
            final entries = MainScreen.of(context).selectedMealEntriesList
                .where((e) => e.mealId == meal.id)
                .toList();

            final bool initialBreakfast = entries.any(
              (e) => e.mealTime == MealTime.breakfast,
            );
            final bool initialLunch = entries.any(
              (e) => e.mealTime == MealTime.lunch,
            );
            final bool initialDinner = entries.any(
              (e) => e.mealTime == MealTime.dinner,
            );

            final List<MealTime>? picked = await showDialog<List<MealTime>>(
              context: context,
              barrierDismissible: false,
              builder: (_) => MealTimeDialog(
                initialBreakfast: initialBreakfast,
                initialLunch: initialLunch,
                initialDinner: initialDinner,
              ),
            );

            if (picked != null) {
              final currentTimes = <MealTime>[];
              if (initialBreakfast) currentTimes.add(MealTime.breakfast);
              if (initialLunch) currentTimes.add(MealTime.lunch);
              if (initialDinner) currentTimes.add(MealTime.dinner);

              // times to remove are those currently selected but not present in picked
              final toRemove = currentTimes
                  .where((t) => !picked.contains(t))
                  .toList();

              if (toRemove.isNotEmpty) {
                MainScreen.of(
                  context,
                ).removeSelectedMealEntriesForMealTimes(meal, toRemove);
              }

              if (picked.isEmpty) {
                // all removed
                Navigator.pop(context, 'removed');
              } else {
                // partially updated
                Navigator.pop(context, 'updated');
              }
            }
          }
        },
      ),
    );
  }
}
