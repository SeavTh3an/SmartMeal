class Nutrition {
  final double calories;
  final double protein;
  final double sugar;
  final double fat;
  final bool vegetables;

  const Nutrition({
    required this.calories,
    required this.protein,
    required this.sugar,
    required this.fat,
    required this.vegetables,
  });

  Map<String, dynamic> toJson() => {
        'calories': calories,
        'protein': protein,
        'sugar': sugar,
        'fat': fat,
        'vegetables': vegetables,
      };

  factory Nutrition.fromJson(Map<String, dynamic> json) => Nutrition(
    calories: (json['calories'] as num).toDouble(),
    protein: (json['protein'] as num).toDouble(),
    sugar: (json['sugar'] as num).toDouble(),
    fat: (json['fat'] as num).toDouble(),
    vegetables: json['vegetables'] as bool,
  );
}

extension NutritionLevel on Nutrition {
  String caloriesLevel() {
    if (calories < 300) return "Low";
    if (calories < 600) return "Medium";
    return "High";
  }

  String proteinLevel() {
    if (protein < 10) return "Low";
    if (protein < 20) return "Medium";
    return "High";
  }

  String sugarLevel() {
    if (sugar < 5) return "Low";
    if (sugar < 15) return "Medium";
    return "High";
  }

  String fatLevel() {
    if (fat < 8) return "Low";
    if (fat < 18) return "Medium";
    return "High";
  }

  String vegetableLevel() {
    return vegetables ? "High" : "Low";
  }
}

