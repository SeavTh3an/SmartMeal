import 'package:flutter/material.dart';
import '../../model/meal.dart';
import '../widget/categoryCard.dart';
import '../widget/header/homeHeader.dart';
import 'mainScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const HomeHeader(
            title: 'What should you\n    cook today ?',
            imagePath: 'assets/image/western_img/salad_header.png',
          ),

          // Title
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'Choose Your Fav Category\nFor Today!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Category Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  CategoryCard(
                    title: 'Khmer',
                    imagePath:
                        'assets/image/category_image/prohok_rmbg.png',
                    onTap: () {
                      MainScreen.of(context)
                          .openListFoodWithCategory(Category.khmerFood);
                    },
                  ),
                  CategoryCard(
                    title: 'Western',
                    imagePath:
                        'assets/image/category_image/steak_rmbg.png',
                    onTap: () {
                      MainScreen.of(context)
                          .openListFoodWithCategory(Category.westernFood);
                    },
                  ),
                  CategoryCard(
                    title: 'Dessert',
                    imagePath:
                        'assets/image/category_image/dessert_rmbg.png',
                    onTap: () {
                      MainScreen.of(context)
                          .openListFoodWithCategory(Category.dessert);
                    },
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
