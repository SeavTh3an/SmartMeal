import 'package:flutter/material.dart';
import '../../model/meal.dart';
import '../widget/curveHead.dart';
import '../widget/topNavigation.dart';
import '../widget/categoryCard.dart';
import '../widget/listfoodCard.dart';
import 'mainScreen.dart';

class SelectedFoodScreen extends StatefulWidget {
  const SelectedFoodScreen({super.key});

  @override
  State<SelectedFoodScreen> createState() => _SelectedFoodScreenState();
}

class _SelectedFoodScreenState extends State<SelectedFoodScreen> {

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

  @override
  Widget build(BuildContext context) {
    final selectedMeals = MainScreen.of(context).selectedMealsList;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// HEADER
          SliverToBoxAdapter(
            child: CurvedHeader(
              onMenuTap: _openTopMenu,
              title: 'Your Selected Meals',
            ),
          ),

          /// CATEGORY BAR (UNCHANGED)
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
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 12),
                  CategoryCard(
                    title: 'Khmer',
                    imagePath: 'assets/image/category_image/prohok_rmbg.png',
                    small: true,
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

          /// SELECTED MEALS GRID
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 16),
            sliver: SliverToBoxAdapter(
              child: selectedMeals.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          "No meals selected yet",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : ListfoodCard(meals: selectedMeals),
            ),
          ),
        ],
      ),
    );
  }
}
