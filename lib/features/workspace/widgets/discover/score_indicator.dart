import 'package:flutter/material.dart';

class ScoreIndicator extends StatelessWidget {
  final double score;

  const ScoreIndicator({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final value = (score / 200).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "AI Score ${score.toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          minHeight: 8,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }
}
