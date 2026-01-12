import 'package:flutter/material.dart';
import '../../../model/selectedMeal.dart';

class MealTimeDialog extends StatefulWidget {
  const MealTimeDialog({super.key});

  @override
  State<MealTimeDialog> createState() => _MealTimeDialogState();
}

class _MealTimeDialogState extends State<MealTimeDialog> {
  bool breakfast = false;
  bool lunch = false;
  bool dinner = false;

  Widget _mealOption({
    required String title,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: value
              ? Colors.green.withOpacity(0.12)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value ? Colors.green : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: value ? Colors.green : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      value ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            Checkbox(
              value: value,
              activeColor: Colors.green,
              onChanged: (v) => onChanged(v ?? false),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: const [
                Icon(Icons.restaurant_menu,
                    color: Colors.green, size: 26),
                SizedBox(width: 10),
                Text(
                  'Select Meal Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _mealOption(
              title: 'Breakfast',
              icon: Icons.free_breakfast,
              value: breakfast,
              onChanged: (v) => setState(() => breakfast = v),
            ),
            _mealOption(
              title: 'Lunch',
              icon: Icons.lunch_dining,
              value: lunch,
              onChanged: (v) => setState(() => lunch = v),
            ),
            _mealOption(
              title: 'Dinner',
              icon: Icons.dinner_dining,
              value: dinner,
              onChanged: (v) => setState(() => dinner = v),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    child: Text('Cancel', style: TextStyle(
                      color: Colors.grey[700],
                    )),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final List<MealTime> result = [];

                      if (breakfast) result.add(MealTime.breakfast);
                      if (lunch) result.add(MealTime.lunch);
                      if (dinner) result.add(MealTime.dinner);

                      Navigator.pop(context, result);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: const StadiumBorder(),
                    ),
                    child: Text('Confirm', style: TextStyle(
                      color: Colors.white,
                    )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
