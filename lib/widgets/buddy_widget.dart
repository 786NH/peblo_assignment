import 'package:flutter/material.dart';

class BuddyWidget extends StatelessWidget {
  final bool happy;

  const BuddyWidget({
    super.key,
    required this.happy,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Icon(
        happy
            ? Icons.sentiment_very_satisfied
            : Icons.smart_toy,
        key: ValueKey(happy),
        size: 120,
        color: Colors.deepPurple,
      ),
    );
  }
}