import 'package:flutter/material.dart';
import '../../model/meal.dart';
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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sync selected meals from MainScreen and apply current filter
    allMeals = MainScreen.of(context).selectedMealsList;
    _applyFilter();
    setState(() {});
  }

  void refresh() {
    // Re-sync and re-filter when MainScreen notifies
    allMeals = MainScreen.of(context).selectedMealsList;
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
    final List<Meal> selectedMeals = MainScreen.of(context).selectedMealsList;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // CURVED HEADER
          SliverToBoxAdapter(
            child: CurvedHeader(
              onMenuTap: _openTopMenu,
              title: 'Your Selected Meals',
            ),
          ),

          //CATEGORY FILTER
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
                    onTap: () => _onCategoryTap(null),
                  ),
                  const SizedBox(width: 12),
                  CategoryCard(
                    title: 'Khmer',
                    imagePath: 'assets/image/category_image/prohok_rmbg.png',
                    small: true,
                    onTap: () => _onCategoryTap(Category.khmerFood),
                  ),
                  const SizedBox(width: 12),
                  CategoryCard(
                    title: 'Western',
                    imagePath: 'assets/image/category_image/steak_rmbg.png',
                    small: true,
                    onTap: () => _onCategoryTap(Category.westernFood),
                  ),
                  const SizedBox(width: 12),
                  CategoryCard(
                    title: 'Dessert',
                    imagePath: 'assets/image/category_image/dessert_rmbg.png',
                    small: true,
                    onTap: () => _onCategoryTap(Category.dessert),
                  ),
                ],
              ),
            ),
          ),

          //Title
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                'You have selected these meals for today!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // SELECTED MEALS LIST
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 16),
            sliver: SliverToBoxAdapter(
              child: allMeals.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          "No meals selected yet",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                  : (filteredMeals.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Center(
                              child: Text(
                                "No meals in this category",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : ListfoodCard(meals: filteredMeals)),
            ),
          ),
        ],
      ),
    );
  }
}
