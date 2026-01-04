import 'package:flutter/material.dart';

class MealDetail extends StatelessWidget {
  const MealDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Detail'),
      ),
      body: const Center(
        child: Text(
          'This is MEAL DETAIL screen',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
