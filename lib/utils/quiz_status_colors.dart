import 'package:flutter/material.dart';

Color getQuizStatusColor({
  required String category,
  required int total,
  required int correct,
  required int wrong,
  required int help,
}) {
  // Define category-specific requirements
  final int minimumCorrect = category == 'A' ? 17 : 22;

  // Check if total questions don't meet the requirement
  if (total < minimumCorrect) {
    return Colors.redAccent.withValues(alpha: 0.2);
  }

  // Check if correct answers meet minimum requirement
  if (correct >= minimumCorrect && total >= minimumCorrect) {
    // If help was used, return yellow, otherwise green
    return help > 4 ? Colors.yellowAccent.withValues(alpha: 0.2) : Colors.greenAccent.withValues(alpha: 0.2);
  }

  // If none of the above conditions are met, return red
  return Colors.redAccent.withValues(alpha: 0.2);
}
