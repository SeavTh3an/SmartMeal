import 'package:flutter/material.dart';
import 'package:smart_meal/model/nutrition.dart';
import '../../model/meal.dart';
import '../widget/nutritionRow.dart';
import 'mainScreen.dart';

class MealDetailScreen extends StatefulWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER WITH CURVE
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

                /// BACK BUTTON
                Positioned(
                  top: 50,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                /// TITLE
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

                /// IMAGE (OVERLAP)
                Positioned(
                  bottom: -50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
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

            /// MEAL NAME
            Text(
              widget.meal.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 3),

            /// DESCRIPTION
            Text(
              widget.meal.description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            //NUTRITION TITLE
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nutritional Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// NUTRITION INFO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  NutritionRow(
                    label: "Calories",
                    level: widget.meal.nutrition.caloriesLevel(),
                    icon: Icons.local_fire_department,
                  ),
                  NutritionRow(
                    label: "Protein",
                    level: widget.meal.nutrition.proteinLevel(),
                    icon: Icons.fitness_center,
                  ),
                  NutritionRow(
                    label: "Sugar",
                    level: widget.meal.nutrition.sugarLevel(),
                    icon: Icons.cake,
                  ),
                  NutritionRow(
                    label: "Fats",
                    level: widget.meal.nutrition.fatLevel(),
                    icon: Icons.opacity,
                  ),
                  NutritionRow(
                    label: "Vegetable",
                    level: widget.meal.nutrition.vegetableLevel(),
                    icon: Icons.eco,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            ///INGREDIENT LIST
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Ingredients",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.meal.ingredients.map((ingredient) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("•  ", style: TextStyle(fontSize: 16)),
                          Expanded(
                            child: Text(
                              ingredient,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            //COOKINGSTEP TITLE
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Cooking Instructions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _sectionContainer(
                child: Text(
                  widget.meal.cookingInstructions,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),

            ///BUTTON
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  /// CANCEL BUTTON
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  /// SELECT BUTTON
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add the meal to selected meals
                        MainScreen.of(context).addSelectedMeal(widget.meal);

                        // Pop back to MainScreen first
                        Navigator.pop(context);

                        // Switch to Selected tab after a tiny delay
                        Future.delayed(const Duration(milliseconds: 50), () {
                          MainScreen.of(context).changeTab(3);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6FA55A),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Select",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
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

  Widget _sectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFCBF4B1).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _bulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("•  ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text("", style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
