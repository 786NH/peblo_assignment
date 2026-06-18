import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrectAnswer;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isCorrectAnswer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.deepPurple.shade100;
    Color backgroundColor = Colors.white;
    IconData? icon;

    if (isSelected) {
      if (isCorrectAnswer) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(.1);
        icon = Icons.check_circle;
      } else {
        borderColor = Colors.red;
        backgroundColor = Colors.red.withOpacity(.1);
        icon = Icons.cancel;
      }
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: isSelected
                      ? borderColor
                      : Colors.black87,
                ),
              ),
            ),

            if (icon != null)
              Icon(
                icon,
                color: borderColor,
              ),
          ],
        ),
      ),
    );
  }
}