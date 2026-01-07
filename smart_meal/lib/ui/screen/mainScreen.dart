import 'package:flutter/material.dart';
import 'package:smart_meal/model/meal.dart';

import 'homeScreen.dart';
import 'listfoodScreen.dart';
import 'addfoodScreen.dart';
import 'selectedfoodScreen.dart';

final GlobalKey<SelectedFoodScreenState> selectedFoodKey =
    GlobalKey<SelectedFoodScreenState>();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static _MainScreenState of(BuildContext context) {
    final state = context.findAncestorStateOfType<_MainScreenState>();
    assert(state != null, 'MainScreen not found in context');
    return state!;
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Category? selectedCategory;

  final List<Meal> selectedMeals = [];

  List<Meal> get selectedMealsList => selectedMeals;

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
      if (index != 1)
        selectedCategory = null; // reset category when leaving list food

      if (index == 3) {
        // Get the SelectedFoodScreen state and refresh
      }
    });
  }

  void openListFoodWithCategory(Category? category) {
    setState(() {
      selectedCategory = category;
      _currentIndex = 1; // switch to ListFoodScreen
    });
  }

  void addSelectedMeal(Meal meal) {
    if (!selectedMeals.contains(meal)) {
      selectedMeals.add(meal);
    }
    // 🔥 FORCE SelectedFoodScreen rebuild
    selectedFoodKey.currentState?.refresh();
  }

  void removeSelectedMeal(Meal meal) {
    if (selectedMeals.contains(meal)) {
      selectedMeals.remove(meal);
      // 🔥 FORCE SelectedFoodScreen rebuild
      selectedFoodKey.currentState?.refresh();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomeScreen(),
          ListFoodScreen(initialCategory: selectedCategory),
          const AddFoodScreen(),
          SelectedFoodScreen(key: selectedFoodKey),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: changeTab,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: const Color(0xFF5F6F52),
        backgroundColor: const Color(0xFFCBF4B1),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'List Food',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add Food',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Selected',
          ),
        ],
      ),
    );
  }
}
