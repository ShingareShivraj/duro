import 'package:flutter/material.dart';

class PeriodFilterChip extends StatelessWidget {
  final String period;
  final String selectedPeriod;
  final Function(String) onSelected;

  const PeriodFilterChip({
    super.key,
    required this.period,
    required this.selectedPeriod,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedPeriod == period;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(period),
        selected: isSelected,
        onSelected: (_) => onSelected(period),

        // Selected chip (clicked one)
        selectedColor: Colors.white,

        // Unselected chip (VERY IMPORTANT)
        backgroundColor: Colors.white.withOpacity(0.15),

        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
        ),

        shape: const StadiumBorder(
          side: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}