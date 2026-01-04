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

  // Auto-generate ID based on category
  static String generateDisplayID(Category category) {
    _categoryCounter[category] = (_categoryCounter[category] ?? 0) + 1;
    final count = _categoryCounter[category]!;
    final prefix = _getPrefix(category);
    final number = count.toString().padLeft(3, '0');
    return '$prefix$number';
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

  // Convert Meal object to JSON
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

  // Convert JSON to Meal object
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
