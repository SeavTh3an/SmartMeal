import 'package:flutter/material.dart';
import '../../model/meal.dart';
import '../../model/selectedMeal.dart';
import '../widget/header/curveHead.dart';
import '../widget/topNavigation.dart';
import '../widget/categoryCard.dart';
import '../widget/listfoodCard.dart';
import 'mainScreen.dart';
import 'listfoodScreen.dart';

class SelectedFoodScreen extends StatefulWidget {
  const SelectedFoodScreen({super.key});

  @override
  State<SelectedFoodScreen> createState() => SelectedFoodScreenState();
}

class SelectedFoodScreenState extends State<SelectedFoodScreen> {
  Category? selectedCategory;
  List<Meal> allMeals = [];
  List<Meal> filteredMeals = [];

  // New: selected entries and grouping by meal time
  List<SelectedMeal> selectedEntries = [];
  List<Meal> breakfastMeals = [];
  List<Meal> lunchMeals = [];
  List<Meal> dinnerMeals = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    allMeals = MainScreen.of(context).selectedMealsList;
    selectedEntries = MainScreen.of(context).selectedMealEntriesList;
    _applyFilter();
    setState(() {});
  }

  void refresh() {
    allMeals = MainScreen.of(context).selectedMealsList;
    selectedEntries = MainScreen.of(context).selectedMealEntriesList;
    _applyFilter();
    setState(() {});
  }

  void _openTopMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => TopMenuSheet(
        currentIndex: 3,
        onSelected: (index) {
          MainScreen.of(context).changeTab(index);
        },
      ),
    );
  }

  void _onCategoryTap(Category? category) {
    setState(() {
      selectedCategory = category;
      _applyFilter();
    });
  }

  void _applyFilter() {
    // Map selected entries to Meal objects and split by mealTime
    breakfastMeals = [];
    lunchMeals = [];
    dinnerMeals = [];

    for (final entry in selectedEntries) {
      final matched = allMeals.where((m) => m.id == entry.mealId);
      if (matched.isEmpty) continue;
      final meal = matched.first;
      if (selectedCategory != null && meal.category != selectedCategory)
        continue;
      switch (entry.mealTime) {
        case MealTime.breakfast:
          if (!breakfastMeals.contains(meal)) breakfastMeals.add(meal);
          break;
        case MealTime.lunch:
          if (!lunchMeals.contains(meal)) lunchMeals.add(meal);
          break;
        case MealTime.dinner:
          if (!dinnerMeals.contains(meal)) dinnerMeals.add(meal);
          break;
      }
    }

    // Also maintain filteredMeals for compatibility (all selected meals filtered by category)
    if (selectedCategory == null) {
      filteredMeals = allMeals;
    } else {
      filteredMeals = allMeals
          .where((meal) => meal.category == selectedCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CurvedHeader(
              onMenuTap: _openTopMenu,
              title: 'Your Selected Meals',
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 90,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryCard(
                    title: 'All',
                    imagePath: 'assets/image/category_image/all.png',
                    small: true,
                    selected: selectedCategory == null,
                    onTap: () => _onCategoryTap(null),
                  ),
                  const SizedBox(width: 12),
                  CategoryCard(
                    title: 'Khmer',
                    imagePath: 'assets/image/category_image/prohok_rmbg.png',
                    small: true,
                    selected: selectedCategory == Category.khmerFood,
                    onTap: () => _onCategoryTap(Category.khmerFood),
                  ),
                  const SizedBox(width: 12),
                  CategoryCard(
                    title: 'Western',
                    imagePath: 'assets/image/category_image/steak_rmbg.png',
                    small: true,
                    selected: selectedCategory == Category.westernFood,
                    onTap: () => _onCategoryTap(Category.westernFood),
                  ),
                  const SizedBox(width: 12),
                  CategoryCard(
                    title: 'Dessert',
                    imagePath: 'assets/image/category_image/dessert_rmbg.png',
                    small: true,
                    selected: selectedCategory == Category.dessert,
                    onTap: () => _onCategoryTap(Category.dessert),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                'You have selected these meals for today!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.only(bottom: 16),
            sliver: SliverToBoxAdapter(
              child: selectedEntries.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          "No meals selected yet",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Breakfast
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: Text(
                            'Breakfast',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: breakfastMeals.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    'No breakfast selected',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListfoodCard(meals: breakfastMeals),
                        ),

                        // Lunch
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: Text(
                            'Lunch',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: lunchMeals.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    'No lunch selected',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListfoodCard(meals: lunchMeals),
                        ),

                        // Dinner
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: Text(
                            'Dinner',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: dinnerMeals.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    'No dinner selected',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListfoodCard(meals: dinnerMeals),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
