import 'package:flutter/material.dart';
import '../../data/meal_loader.dart';
import '../../model/meal.dart';
import '../widget/categoryCard.dart';
import '../widget/listfoodCard.dart';
import '../widget/header/curveHead.dart';
import '../widget/searchbar.dart';
import 'mainScreen.dart';
import '../widget/topNavigation.dart';
import '../../data/meal_storagedata.dart';

class ListFoodScreen extends StatefulWidget {
  final Category? initialCategory;

  const ListFoodScreen({super.key, this.initialCategory});

  @override
  ListFoodScreenState createState() => ListFoodScreenState();
}

class ListFoodScreenState extends State<ListFoodScreen> {
  List<Meal> allMeals = [];
  List<Meal> filteredMeals = [];
  bool isLoading = true;
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    _loadMeals();
  }

  @override
  void didUpdateWidget(covariant ListFoodScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCategory != widget.initialCategory) {
      setState(() {
        selectedCategory = widget.initialCategory;
        _applyFilter();
      });
    }
  }

  Future<void> _loadMeals() async {
    final assetMeals = await MealLoader.loadMeals();
    final userMeals = await MealStorage.loadUserMeals();
    setState(() {
      allMeals = [...assetMeals, ...userMeals];
      _applyFilter();
      isLoading = false;
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

  void _searchMeals(String query) {
    final result = allMeals.where((meal) {
      final matchesCategory =
          selectedCategory == null || meal.category == selectedCategory;
      final matchesName = meal.name.toLowerCase().contains(query.toLowerCase());
      return matchesCategory && matchesName;
    }).toList();

    setState(() {
      filteredMeals = result;
    });
  }

  void _onCategoryTap(Category? category) {
    setState(() {
      selectedCategory = category;
      _applyFilter();
    });
  }

  void addMeal(Meal meal) async {
  setState(() {
    allMeals.add(meal);
    _applyFilter();
  });

  final userMeals = allMeals.where((m) => m.isUserCreated).toList();
  await MealStorage.saveUserMeals(userMeals);
}

  // void refreshMeals() {
  //   setState(() {
  //     _applyFilter();
  //   });
  // }

  void _openTopMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => TopMenuSheet(
        currentIndex: 1,
        onSelected: (index) {
          MainScreen.of(context).changeTab(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CurvedHeader(
              title: "Find Your Meal For Today!",
              onMenuTap: _openTopMenu,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SearchBarWidget(onChanged: _searchMeals),
              ),
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
          SliverToBoxAdapter(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Choose Your Meal For Today!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 16),
            sliver: SliverToBoxAdapter(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListfoodCard(meals: filteredMeals),
            ),
          ),
        ],
      ),
    );
  }
}
