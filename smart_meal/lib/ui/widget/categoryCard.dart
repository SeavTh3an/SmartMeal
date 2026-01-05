import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool small;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.small = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double imageSize = small ? 40 : 80;
    final double fontSize = small ? 12 : 16;
    final double radius = small ? 14 : 20;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(small ? 8 : 0),
        decoration: BoxDecoration(
          color: const Color(0xFFCBF4B1),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(imageSize),
              child: Image.asset(
                imagePath,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF264016),
              ),
            ),
          ],
        ),
      ),
    );
  }
}