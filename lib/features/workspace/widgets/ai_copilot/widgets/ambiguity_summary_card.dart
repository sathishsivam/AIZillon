import 'package:flutter/material.dart';

import 'confidence_indicator.dart';

class AmbiguitySummaryCard extends StatelessWidget {
  final String businessTerm;
  final int candidateCount;
  final double confidence;
  final String reason;

  const AmbiguitySummaryCard({
    super.key,
    required this.businessTerm,
    required this.candidateCount,
    required this.confidence,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ambiguity Detected",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: _info(
                    "Business Term",
                    businessTerm,
                    Icons.help_outline,
                  ),
                ),
                Expanded(
                  child: _info(
                    "Candidates",
                    candidateCount.toString(),
                    Icons.account_tree_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ConfidenceIndicator(confidence: confidence),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      reason,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }
}
