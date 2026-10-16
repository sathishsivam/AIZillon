import 'package:flutter/material.dart';

import '../../../models/discover/ranked_table.dart';

class AIReasonCard extends StatelessWidget {
  final RankedTable approvedTable;

  const AIReasonCard({super.key, required this.approvedTable});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.psychology_alt_outlined, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text(
                  "Why did AI choose this table?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _info(
              "Selected Table",
              approvedTable.table,
              Icons.table_chart_outlined,
            ),

            const SizedBox(height: 20),

            _info(
              "Confidence",
              "${approvedTable.score.toStringAsFixed(1)}%",
              Icons.analytics_outlined,
            ),

            const SizedBox(height: 20),

            _info(
              "Matched Business Terms",
              approvedTable.matchedTerms.join(", "),
              Icons.sell_outlined,
            ),

            const SizedBox(height: 20),

            const Divider(),

            const SizedBox(height: 12),

            const Text(
              "AI Reasoning",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 10),

            const Text(
              "The semantic search engine compared your business question "
              "against all enterprise metadata. "
              "This table achieved the highest similarity score based on "
              "business terms, metadata, and historical relevance.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}
