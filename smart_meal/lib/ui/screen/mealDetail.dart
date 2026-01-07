import 'package:flutter/material.dart';
import 'package:smart_meal/model/nutrition.dart';
import '../../model/meal.dart';
import '../widget/nutritionRow.dart'; 
import 'mainScreen.dart';

class MealDetailScreen extends StatefulWidget {
  final Meal meal;
  final bool isSelected;

  const MealDetailScreen({
    super.key,
    required this.meal,
    this.isSelected = false,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  static const Color kDarkGreen = Color(0xFF1F3A22);
  static const Color kRed       = Color(0xFFE85C5C);

  // Light green for section cards
  static const Color kBoxLightGreen = Color(0xFFCBF4B1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER WITH CURVE (unchanged)
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
                    onPressed: () => Navigator.pop(context),
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
                          widget.meal.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 70),

            // MEAL NAME
            Text(
              widget.meal.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: kDarkGreen,
              ),
            ),

            const SizedBox(height: 6),

            // DESCRIPTION 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.meal.description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 24),

            // NUTRITION TITLE
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

            // NUTRITION CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionCard(
                child: Column(
                  children: [
                    NutritionRow(
                      label: "Calories",
                      levelText: widget.meal.nutrition.caloriesLevel(),
                      icon: Icons.local_fire_department,
                    ),
                    const Divider(height: 16),
                    NutritionRow(
                      label: "Protein",
                      levelText: widget.meal.nutrition.proteinLevel(),
                      icon: Icons.fitness_center,
                    ),
                    const Divider(height: 16),
                    NutritionRow(
                      label: "Sugar",
                      levelText: widget.meal.nutrition.sugarLevel(),
                      icon: Icons.cake,
                    ),
                    const Divider(height: 16),
                    NutritionRow(
                      label: "Fats",
                      levelText: widget.meal.nutrition.fatLevel(),
                      icon: Icons.opacity,
                    ),
                    const Divider(height: 16),
                    NutritionRow(
                      label: "Vegetable",
                      icon: Icons.eco,
                      booleanValue: widget.meal.nutrition.vegetables,
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

            // INGREDIENTS CARD 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionCard(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: widget.meal.ingredients.map((ingredient) {
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

            // COOKING INSTRUCTIONS TITLE
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

            // COOKING INSTRUCTIONS CARD 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionCard(
                child: Text(
                  widget.meal.cookingInstructions,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),

            // BUTTONS
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Cancel
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.white,
                        side: BorderSide(color: kRed),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: const Text("Cancel", style: TextStyle(fontSize: 16, color: kRed)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Select and Unselect
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final bool isSelected = widget.isSelected;
                        return ElevatedButton(
                          onPressed: () {
                            if (isSelected) {
                              Navigator.pop(context, 'removed');
                            } else {
                              Navigator.pop(context, true);
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  //Light green section card 
  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBoxLightGreen.withOpacity(0.45),                 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDEFD0), width: 1), 
      ),
      child: child,
    );
  }
}
