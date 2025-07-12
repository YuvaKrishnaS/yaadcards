import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class ColorPickerGrid extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorSelected;

  const ColorPickerGrid({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: Flashcard.predefinedColors.length,
      itemBuilder: (context, index) {
        final color = Flashcard.predefinedColors[index];
        final isSelected = color.value == selectedColor.value;

        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
                  : null,
            ),
            child: isSelected
                ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 20,
            )
                : null,
          ),
        );
      },
    );
  }
}