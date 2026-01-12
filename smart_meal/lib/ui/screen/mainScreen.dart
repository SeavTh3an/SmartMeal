import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:smart_meal/model/meal.dart';
import 'package:smart_meal/model/selectedMeal.dart';
import '../../data/selected_meal_storage.dart';
import '../../data/meal_loader.dart';
import 'homeScreen.dart';
import 'listfoodScreen.dart';
import 'addfoodScreen.dart';
import 'selectedfoodScreen.dart';

final GlobalKey<SelectedFoodScreenState> selectedFoodKey =
    GlobalKey<SelectedFoodScreenState>();
final GlobalKey<ListFoodScreenState> listFoodKey =
    GlobalKey<ListFoodScreenState>();

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
  final List<SelectedMeal> selectedMealEntries = [];

  List<Meal> get selectedMealsList => selectedMeals;
  List<SelectedMeal> get selectedMealEntriesList => selectedMealEntries;

  @override
  void initState() {
    super.initState();
    _loadSelectedEntries();
  }

  Future<void> _loadSelectedEntries() async {
    final List<SelectedMeal> entries =
        await SelectedMealStorage.loadSelectedMealEntries();
    selectedMealEntries.clear();
    selectedMealEntries.addAll(entries);

    // Reconstruct selected Meal objects from the saved mealIds so Selected screen can display them
    try {
      final allMeals = await MealLoader.loadMeals();
      selectedMeals.clear();
      final ids = selectedMealEntries.map((e) => e.mealId).toSet();
      for (final id in ids) {
        final match = allMeals.where((m) => m.id == id);
        if (match.isNotEmpty) selectedMeals.add(match.first);
      }
    } catch (e) {
      // if meals can't be loaded for any reason, leave selectedMeals as-is
      debugPrint('Warning: could not rebuild selectedMeals: $e');
    }

    selectedFoodKey.currentState?.refresh();
  }

  Future<void> _saveSelectedEntries() async {
    await SelectedMealStorage.saveSelectedMealEntries(selectedMealEntries);
  }

  bool isMealSelected(Meal meal) {
    return selectedMealEntries.any((e) => e.mealId == meal.id);
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
      if (index != 1) selectedCategory = null;
    });
  }

  void openListFoodWithCategory(Category? category) {
    setState(() {
      selectedCategory = category;
      _currentIndex = 1;
    });
  }

  void addSelectedMeal(Meal meal) {
    if (!selectedMeals.contains(meal)) {
      selectedMeals.add(meal);
      selectedFoodKey.currentState?.refresh();
    }
  }

  /// Add one or multiple SelectedMeal entries for a meal (preserves meal object in selectedMeals)
  Future<void> addSelectedMealEntriesForMeal(
    Meal meal,
    List<MealTime> mealTimes,
  ) async {
    if (mealTimes.isEmpty) return;
    final uid = const Uuid();
    for (final mt in mealTimes) {
      final exists = selectedMealEntries.any(
        (e) => e.mealId == meal.id && e.mealTime == mt,
      );
      if (exists) continue;
      final entry = SelectedMeal(
        id: uid.v4(),
        mealId: meal.id,
        mealTime: mt,
        date: DateTime.now(),
      );
      selectedMealEntries.add(entry);
    }
    

    // ensure the meal object is in the selectedMeals list for compatibility with existing code
    addSelectedMeal(meal);

    await _saveSelectedEntries();
    selectedFoodKey.currentState?.refresh();
  }

  Future<void> removeSelectedMeal(Meal meal) async {
    try {
      if (selectedMeals.contains(meal)) {
        selectedMeals.remove(meal);
      }
      // also remove any selected entries for this meal
      selectedMealEntries.removeWhere((e) => e.mealId == meal.id);
      await _saveSelectedEntries();
      selectedFoodKey.currentState?.refresh();
    } catch (e, st) {
      debugPrint('Error in removeSelectedMeal: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  /// Remove specific meal-time entries for a meal; if none remain, also unmark the meal
  void removeSelectedMealEntriesForMealTimes(Meal meal, List<MealTime> times) {
    if (times.isEmpty) return;
    selectedMealEntries.removeWhere(
      (e) => e.mealId == meal.id && times.contains(e.mealTime),
    );

    final remainingForMeal = selectedMealEntries.where(
      (e) => e.mealId == meal.id,
    );
    if (remainingForMeal.isEmpty) {
      // no more times selected for this meal -> remove meal from selectedMeals
      selectedMeals.remove(meal);
    }

    _saveSelectedEntries();
    selectedFoodKey.currentState?.refresh();
  }

  void addNewMealToList(Meal meal) {
    listFoodKey.currentState?.addMeal(meal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(),
          ListFoodScreen(key: listFoodKey, initialCategory: selectedCategory),
          AddFoodScreen(), // calls addNewMealToList
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
