  import 'package:flutter/material.dart';

  import '../../data/meal_loader.dart';
  import '../../model/meal.dart';
  import '../widget/categoryCard.dart';
  import '../widget/listfoodCard.dart';
  import '../widget/curveHead.dart';
  import '../widget/searchbar.dart';
  import '../widget/topNavigation.dart';
  import 'mainScreen.dart';

  class ListFoodScreen extends StatefulWidget {
    const ListFoodScreen({super.key});
    

    @override
    State<ListFoodScreen> createState() => _ListFoodScreenState();
  }

  class _ListFoodScreenState extends State<ListFoodScreen> {
    List<Meal> allMeals = [];
    List<Meal> filteredMeals = [];
    bool isLoading = true;

    @override
    void initState() {
      super.initState();
      _loadMeals();
    }

    Future<void> _loadMeals() async {
      final loadedMeals = await MealLoader.loadMeals();
      setState(() {
        allMeals = loadedMeals;
        filteredMeals = loadedMeals;
        isLoading = false;
      });
    }

    void _searchMeals(String query) {
      final result = allMeals.where((meal) {
        return meal.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        filteredMeals = result;
      });
    }

    void _openTopMenu() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => TopMenuSheet(
          currentIndex: 1, // ListFood tab index
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
            /// 🔝 CURVED HEADER (scrolls)
            SliverToBoxAdapter(
              child: CurvedHeader(
                onMenuTap: _openTopMenu,
                title: "Find Your Meal For Today!",
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SearchBarWidget(onChanged: _searchMeals),
                ),
              ),
            ),

            /// 🍱 CATEGORY FILTER (SMALL)
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
                      onTap: () {
                        setState(() {
                          filteredMeals = allMeals;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    CategoryCard(
                      title: 'Khmer',
                      imagePath: 'assets/image/category_image/prohok_rmbg.png',
                      small: true,
                      onTap: () {
                        // filter later
                      },
                    ),
                    const SizedBox(width: 12),
                    CategoryCard(
                      title: 'Western',
                      imagePath: 'assets/image/category_image/steak_rmbg.png',
                      small: true,
                    ),
                    const SizedBox(width: 12),
                    CategoryCard(
                      title: 'Dessert',
                      imagePath: 'assets/image/category_image/dessert_rmbg.png',
                      small: true,
                    ),
                  ],
                ),
              ),
            ),

            /// 📝 TITLE
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Choose Your Meal For Today!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            /// 🍽 CONTENT
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 16),
              sliver: SliverToBoxAdapter(
                child: isLoading
                    ? const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : ListfoodCard(meals: filteredMeals),
              ),
            ),
          ],
        ),
      );
    }
  }
