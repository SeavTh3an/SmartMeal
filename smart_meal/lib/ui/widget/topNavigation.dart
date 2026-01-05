import 'package:flutter/material.dart';

class TopMenuSheet extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelected;

  const TopMenuSheet({
    super.key,
    required this.currentIndex,
    required this.onSelected,
  });

  static const Color selectedColor = Color(0xFF2E7D32);
  static const Color unselectedColor = Color(0xFF5F6F52);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFCBF4B1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _item(context, Icons.home, 'Home', 0),
          _item(context, Icons.food_bank, 'List Food', 1),
          _item(context, Icons.add_circle, 'Add Food', 2),
          _item(context, Icons.favorite, 'Selected', 3),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, int index) {
    final bool isSelected = index == currentIndex;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? selectedColor : unselectedColor,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? selectedColor : unselectedColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onSelected(index);
      },
    );
  }
}
