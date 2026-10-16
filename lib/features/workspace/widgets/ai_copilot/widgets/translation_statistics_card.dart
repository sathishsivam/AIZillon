import 'package:flutter/material.dart';

class TranslationStatisticsCard extends StatelessWidget {
  final int mappedColumns;
  final int businessTerms;
  final int confirmedMappings;
  final double averageConfidence;

  const TranslationStatisticsCard({
    super.key,
    required this.mappedColumns,
    required this.businessTerms,
    required this.confirmedMappings,
    required this.averageConfidence,
  });

  Widget _item(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Translation Statistics",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _item(
                  context,
                  title: "Business Terms",
                  value: businessTerms.toString(),
                  icon: Icons.psychology_alt_outlined,
                  color: Colors.deepPurple,
                ),
                _item(
                  context,
                  title: "Mapped Columns",
                  value: mappedColumns.toString(),
                  icon: Icons.account_tree_outlined,
                  color: Colors.green,
                ),
                _item(
                  context,
                  title: "Confirmed",
                  value: confirmedMappings.toString(),
                  icon: Icons.verified,
                  color: Colors.orange,
                ),
                _item(
                  context,
                  title: "Confidence",
                  value: "${(averageConfidence * 100).toStringAsFixed(0)}%",
                  icon: Icons.auto_graph,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
