import 'package:flutter/material.dart';

class ConfidenceBadge extends StatelessWidget {
  final double score;

  const ConfidenceBadge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    if (score >= 120) {
      text = "HIGH";
      color = Colors.green;
    } else if (score >= 50) {
      text = "MEDIUM";
      color = Colors.orange;
    } else {
      text = "LOW";
      color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
