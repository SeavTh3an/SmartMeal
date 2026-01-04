import 'package:flutter/material.dart';

class SelectedFoodScreen extends StatelessWidget {
  const SelectedFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'This is SELECTED FOOD screen',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
