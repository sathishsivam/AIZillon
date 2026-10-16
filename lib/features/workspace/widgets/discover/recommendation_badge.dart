import 'package:flutter/material.dart';

class RecommendationBadge extends StatelessWidget {
  final bool recommended;

  const RecommendationBadge({super.key, required this.recommended});

  @override
  Widget build(BuildContext context) {
    if (!recommended) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 16, color: Colors.orange),
          SizedBox(width: 4),
          Text(
            "Recommended",
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
