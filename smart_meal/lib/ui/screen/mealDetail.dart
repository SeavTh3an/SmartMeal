import 'package:flutter/material.dart';

import '../../model/meal.dart';
import '../../model/selectedMeal.dart';
import '../widget/mealDetail/mealDetailWidget.dart';
import '../widget/mealDetail/dialog.dart';
import '../widget/mealDetail/removedialog.dart';

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
          //select
          if (nextSelected) {
            final List<MealTime>? picked =
                await showDialog<List<MealTime>>(
              context: context,
              barrierDismissible: false,
              builder: (_) => const MealTimeDialog(),
            );

            if (picked != null && picked.isNotEmpty) {
              Navigator.pop(context, picked);
            }
            return;
          }

final action = await showRemoveMealSheet(context);

if (action == 'remove') {
  Navigator.pop(context, 'removed');
  return;
}

if (action == 'edit') {
  Navigator.pop(context, 'edit');
}

        },
      ),
    );
  }
}