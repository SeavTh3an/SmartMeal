import 'package:flutter/material.dart';
import '../../model/meal.dart';
import '../../data/meal_loader.dart';

class ListfoodCard extends StatefulWidget {
  const ListfoodCard({super.key, required List<Meal> meals});

  @override
  State<ListfoodCard> createState() => _ListfoodCardState();
}

class _ListfoodCardState extends State<ListfoodCard> {
  List<Meal> meals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  Future<void> loadMeals() async {
    final loadedMeals = await MealLoader.loadMeals();
    setState(() {
      meals = loadedMeals;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meals.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final meal = meals[index];
        final score = meal.healthScore;

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFCBF4B1).withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(
                  meal.image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// MEAL NAME
                    Text(
                      meal.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// HEALTH LABEL
                    Text(
                      meal.healthLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// HEALTH BAR
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: score,
                        minHeight: 6,
                        backgroundColor: Colors.white70,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          score < 0.4
                              ? Colors.orange
                              : score < 0.7
                                  ? Colors.yellow
                                  : Colors.green,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// VIEW DETAIL BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E4A21),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => _showMealDetail(context, meal),
                        child: const Text(
                          'View Detail',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ---------- DETAIL DIALOG ----------
  void _showMealDetail(BuildContext context, Meal meal) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(meal.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow('Calories', '${meal.nutrition.calories} kcal'),
              _infoRow('Protein', '${meal.nutrition.protein} g'),
              _infoRow('Sugar', '${meal.nutrition.sugar} g'),
              _infoRow('Fat', '${meal.nutrition.fat} g'),
              _infoRow(
                'Vegetables',
                meal.nutrition.vegetables ? 'Yes' : 'No',
              ),
              const SizedBox(height: 12),
              const Text(
                'Ingredients',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(meal.ingredients.join(', ')),
              const SizedBox(height: 12),
              const Text(
                'Cooking Instructions',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(meal.cookingInstructions),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text('$title: $value'),
    );
  }
}
