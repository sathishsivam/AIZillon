import 'package:flutter/material.dart';

class AIRecommendationCard extends StatelessWidget {
  final String recommendedColumn;
  final String businessName;
  final double confidence;
  final List<String> reasons;

  const AIRecommendationCard({
    super.key,
    required this.recommendedColumn,
    required this.businessName,
    required this.confidence,
    required this.reasons,
  });

  Color get _confidenceColor {
    if (confidence >= .90) return Colors.green;
    if (confidence >= .70) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.auto_awesome, color: Colors.white),
                ),

                const SizedBox(width: 14),

                Text(
                  "AI Recommendation",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),

                const SizedBox(width: 12),

                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        const TextSpan(
                          text: "Recommended Column : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: recommendedColumn,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(businessName, style: Theme.of(context).textTheme.titleMedium),

            const SizedBox(height: 20),

            LinearProgressIndicator(
              value: confidence,
              minHeight: 8,
              borderRadius: BorderRadius.circular(20),
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(_confidenceColor),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${(confidence * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  color: _confidenceColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Why this recommendation?",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            ...reasons.map(
              (reason) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_right, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text(reason)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
