import 'package:flutter/material.dart';

import 'homeScreen.dart';
import 'listfoodScreen.dart';
import 'addfoodScreen.dart';
import 'selectedfoodScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  /// Allow child screens to change bottom navigation index
  static _MainScreenState of(BuildContext context) {
    final state = context.findAncestorStateOfType<_MainScreenState>();
    assert(state != null, 'MainScreen not found in widget tree');
    return state!;
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Screens controlled ONLY by index
  final List<Widget> _screens = const [
    HomeScreen(),
    ListFoodScreen(),
    AddFoodScreen(),
    SelectedFoodScreen(),
  ];

  // 🎨 Colors
  static const Color navBgColor = Color(0xFFCBF4B1);
  static const Color selectedColor = Color(0xFF2E7D32);
  static const Color unselectedColor = Color(0xFF5F6F52);

  /// Called by bottom nav OR top menu
  void changeTab(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: navBgColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: navBgColor,
          currentIndex: _currentIndex,
          onTap: changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: selectedColor,
          unselectedItemColor: unselectedColor,
          selectedFontSize: 13,
          unselectedFontSize: 12,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.food_bank_rounded),
              label: 'List Food',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_rounded),
              label: 'Add Food',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Selected',
            ),
          ],
        ),
      ),
    );
  }
}
