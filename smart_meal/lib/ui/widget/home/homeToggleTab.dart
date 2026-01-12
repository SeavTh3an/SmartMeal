import 'package:flutter/material.dart';

enum HomeView { today, weekly }

class HomeToggleTab extends StatelessWidget {
  final HomeView current;
  final ValueChanged<HomeView> onChanged;

  const HomeToggleTab({
    super.key,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: HomeView.values.map((view) {
          final selected = view == current;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(view),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  view == HomeView.today ? 'Today' : 'Weekly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
