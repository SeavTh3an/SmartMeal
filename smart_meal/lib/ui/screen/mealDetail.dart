import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../model/meal.dart';
import '../widget/mealDetail/mealDetailWidget.dart';
import '../../data/meal_loader.dart';
import '../../model/selectedMeal.dart';

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
        onToggleSelected: (nextSelected) {
          if (nextSelected) {
            Navigator.pop(context, true);     
          } else {
            Navigator.pop(context, 'removed'); 
          }
        },
      ),
    );
  }
}

