import 'nutrition.dart';

enum Category { khmerFood, westernFood, dessert }

class Meal {
  static final Map<Category, int> _categoryCounter = {
    Category.khmerFood: 0,
    Category.westernFood: 0,
    Category.dessert: 0,
  };

  const Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.nutrition,
    required this.ingredients,
    required this.cookingInstructions,
  });

  final String id;
  final String name;
  final String description;
  final String image;
  final Category category;
  final Nutrition nutrition;
  final List<String> ingredients;
  final String cookingInstructions;

  // ---------- ID GENERATION ----------
  static String generateDisplayID(Category category) {
    _categoryCounter[category] = (_categoryCounter[category] ?? 0) + 1;
    final count = _categoryCounter[category]!;
    final prefix = _getPrefix(category);
    return '$prefix${count.toString().padLeft(3, '0')}';
  }

  static String _getPrefix(Category category) {
    switch (category) {
      case Category.khmerFood:
        return "KH";
      case Category.westernFood:
        return "WE";
      case Category.dessert:
        return "DE";
    }
  }

  // ---------- HEALTH SCORE (0.0 - 1.0) ----------
  double get healthScore {
    double score = 0;

    // Protein (max 30g → 30%)
    score += (nutrition.protein / 30).clamp(0, 1) * 0.30;

    // Sugar (lower better, max 30g → 25%)
    score += ((30 - nutrition.sugar) / 30).clamp(0, 1) * 0.25;

    // Fat (lower better, max 25g → 20%)
    score += ((25 - nutrition.fat) / 25).clamp(0, 1) * 0.20;

    // Calories (lower better, max 800 kcal → 15%)
    score += ((800 - nutrition.calories) / 800).clamp(0, 1) * 0.15;

    // Vegetables bonus (10%)
    if (nutrition.vegetables) {
      score += 0.10;
    }

    return score.clamp(0, 1);
  }

  // ---------- HEALTH LABEL ----------
  String get healthLabel {
    final value = (healthScore * 10).toStringAsFixed(1);

    if (healthScore < 0.4) {
      return "Less healthy ";
    } else if (healthScore < 0.7) {
      return "Moderate ";
    } else {
      return "Healthy";
    }
  }

  // ---------- JSON ----------
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image': image,
        'category': category.index,
        'nutrition': nutrition.toJson(),
        'ingredients': ingredients,
        'cookingInstructions': cookingInstructions,
      };

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        image: json['image'],
        category: Category.values[json['category']],
        nutrition: Nutrition.fromJson(json['nutrition']),
        ingredients: List<String>.from(json['ingredients']),
        cookingInstructions: json['cookingInstructions'],
      );
}
