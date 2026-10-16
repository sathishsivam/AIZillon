import 'package:flutter/material.dart';

class AIConfidenceBar extends StatelessWidget {
  final double score;

  const AIConfidenceBar({super.key, required this.score});

  Color get color {
    if (score >= 90) return Colors.green;
    if (score >= 70) return Colors.orange;
    return Colors.red;
  }

  String get label {
    if (score >= 90) return "High";
    if (score >= 70) return "Medium";
    return "Low";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "AI Confidence",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Text(
              "${score.toStringAsFixed(0)}%",
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 10,
            color: color,
            backgroundColor: Colors.grey.shade300,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          "$label Confidence",
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
