import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  final String story;

  const StoryCard({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.deepPurple.shade100,
        ),
      ),
      child: Text(
        story,
        style: const TextStyle(
          fontSize: 20,
          height: 1.5,
        ),
      ),
    );
  }
}