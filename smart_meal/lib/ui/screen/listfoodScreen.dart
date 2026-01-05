import 'package:flutter/material.dart';
import '../widget/listfoodCard.dart';
import '../../data/meal_loader.dart';
import '../../model/meal.dart';

class ListFoodScreen extends StatefulWidget {
  const ListFoodScreen({super.key});

  @override
  State<ListFoodScreen> createState() => _ListFoodScreenState();
}

class _ListFoodScreenState extends State<ListFoodScreen> {
  List<Meal> meals = [];

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  Future<void> loadMeals() async {
    final loadedMeals = await MealLoader.loadMeals();
    setState(() {
      meals = loadedMeals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List of Meals')),
      body: meals.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListfoodCard(meals: meals),
    );
  }
}
