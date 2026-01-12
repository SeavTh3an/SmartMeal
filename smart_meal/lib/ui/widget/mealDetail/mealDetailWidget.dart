import 'package:flutter/material.dart';
import 'package:smart_meal/model/nutrition.dart';
import '../../../model/meal.dart';
import 'nutritionRow.dart';

class MealDetailWidget extends StatelessWidget {
  final Meal meal;
  final bool isSelected;

  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final ValueChanged<bool>? onToggleSelected; // passes next selection state

  const MealDetailWidget({
    super.key,
    required this.meal,
    this.isSelected = false,
    this.onBack,
    this.onCancel,
    this.onToggleSelected,
  });

  static const Color kDarkGreen     = Color(0xFF1F3A22);
  static const Color kRed           = Color(0xFFE85C5C);
  static const Color kBoxLightGreen = Color(0xFFCBF4B1);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 220,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFC8F0A5), Color(0xFF6FA55A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: onBack,
                ),
              ),
              const Positioned(
                top: 55,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "Meal Detail",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        meal.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 70),

          //meal name
          Text(
            meal.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 6),

          // description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              meal.description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),

          //nutriton title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Nutritional Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          //nutrition card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SectionCard(
              background: kBoxLightGreen.withOpacity(0.45),
              borderColor: const Color(0xFF2E7D32),
              child: Column(
                children: [
                  NutritionRow(
                    label: "Calories",
                    levelText: meal.nutrition.caloriesLevel(),
                    icon: Icons.local_fire_department,
                  ),
                  const Divider(height: 16),
                  NutritionRow(
                    label: "Protein",
                    levelText: meal.nutrition.proteinLevel(),
                    icon: Icons.fitness_center,
                  ),
                  const Divider(height: 16),
                  NutritionRow(
                    label: "Sugar",
                    levelText: meal.nutrition.sugarLevel(),
                    icon: Icons.cake,
                  ),
                  const Divider(height: 16),
                  NutritionRow(
                    label: "Fats",
                    levelText: meal.nutrition.fatLevel(),
                    icon: Icons.opacity,
                  ),
                  const Divider(height: 16),
                  NutritionRow(
                    label: "Vegetable",
                    icon: Icons.eco,
                    booleanValue: meal.nutrition.vegetables,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          // INGREDIENTS TITLE
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Ingredients",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          //ingredient card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SectionCard(
              background: kBoxLightGreen.withOpacity(0.45),
              borderColor: const Color(0xFF2E7D32),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: meal.ingredients.map((ingredient) {
                  return Chip(
                    backgroundColor: Colors.white,
                    shape: StadiumBorder(
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    label: Text(
                      ingredient,
                      style: const TextStyle(color: kDarkGreen),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // cooking instruction
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Cooking Instructions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          //cooking instructiuon card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SectionCard(
              background: kBoxLightGreen.withOpacity(0.45),
              borderColor: const Color(0xFF2E7D32),
              child: Text(
                meal.cookingInstructions,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ),

          //button
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: kRed),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 16, color: kRed),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (onToggleSelected != null) {
                        onToggleSelected!(!isSelected);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? kRed : kDarkGreen,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      isSelected ? "Unselect" : "Select",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

//section card 
class _SectionCard extends StatelessWidget {
  final Widget child;
  final Color background;
  final Color borderColor;

  const _SectionCard({
    super.key,
    required this.child,
    required this.background,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: child,
    );
  }
}
