import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool small;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.small = false,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double imageSize = small
        ? (selected ? 48 : 40)
        : (selected ? 96 : 80);
    final double fontSize = small ? (selected ? 14 : 12) : (selected ? 18 : 16);
    final double radius = small ? (selected ? 18 : 14) : (selected ? 24 : 20);
    final Color bgColor = selected
        ? const Color(0xFF2E7D32)
        : const Color(0xFFCBF4B1);
    final Color textColor = selected ? Colors.white : const Color(0xFF264016);

    final BoxDecoration decoration = BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: selected
          ? [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ]
          : null,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(
          small ? (selected ? 10 : 8) : (selected ? 12 : 0),
        ),
        decoration: decoration,
        // constrain height so the card fits within the ListView row and avoids small overflows
        constraints: BoxConstraints(maxHeight: small ? 86 : 140, minWidth: 56),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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

            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
