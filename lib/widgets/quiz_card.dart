import 'package:flutter/material.dart';
import 'package:peblo_assignment/models/quiz_model.dart';
import 'package:peblo_assignment/widgets/option_tile.dart';

class QuizCard extends StatelessWidget {
  final QuizModel quiz;
  final String? selectedOption;
  final bool isCorrectAnswer;
  final Function(String) onOptionSelected;

  const QuizCard({
    super.key,
    required this.quiz,
    required this.selectedOption,
    required this.isCorrectAnswer,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          quiz.question,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),

        ...quiz.options.map(
          (option) => OptionTile(
            text: option,
            isSelected: selectedOption == option,
            isCorrectAnswer: isCorrectAnswer,
            onTap: () => onOptionSelected(option),
          ),
        ),
      ],
    );
  }
}