import 'package:flutter/material.dart';

import 'recommendation_badge.dart';
import 'table_icon.dart';

class ApprovalHeader extends StatelessWidget {
  final String tableName;

  final bool recommended;

  final bool approved;

  const ApprovalHeader({
    super.key,
    required this.tableName,
    required this.recommended,
    required this.approved,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const TableIcon(),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                tableName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              if (approved)
                const Text(
                  "✓ Approved",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),

        RecommendationBadge(recommended: recommended),
      ],
    );
  }
}
