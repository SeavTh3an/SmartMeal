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

    // Convert Nutrition object to JSON
  Map<String, dynamic> toJson() => {
        'calories': calories,
        'protein': protein,
        'sugar': sugar,
        'fat': fat,
        'vegetables': vegetables,
      };

  // Convert JSON to Nutrition object
  factory Nutrition.fromJson(Map<String, dynamic> json) => Nutrition(
        calories: json['calories'],
        protein: json['protein'],
        sugar: json['sugar'],
        fat: json['fat'],
        vegetables: json['vegetables'],
      );
}
