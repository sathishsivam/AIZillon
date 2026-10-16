import 'package:flutter/material.dart';

class MappingSummaryCard extends StatelessWidget {
  final String tableName;

  final int detectedTerms;
  final int mappedColumns;

  final double averageConfidence;

  const MappingSummaryCard({
    super.key,
    required this.tableName,
    required this.detectedTerms,
    required this.mappedColumns,
    required this.averageConfidence,
  });

  Widget _metric(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    Color color = Colors.orange,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),

            const SizedBox(height: 12),

            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.translate, color: Colors.white),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Business Language Translation",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "The Intelligence Layer converted your business language into physical database columns.",
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.storage, color: Colors.blue),

                  const SizedBox(width: 12),

                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          const TextSpan(
                            text: "Approved Table : ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          TextSpan(
                            text: tableName,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            Row(
              children: [
                _metric(
                  context,
                  icon: Icons.psychology_alt_outlined,
                  title: "Business Terms",
                  value: detectedTerms.toString(),
                ),

                _metric(
                  context,
                  icon: Icons.check_circle_outline,
                  title: "Mapped Columns",
                  value: mappedColumns.toString(),
                  color: Colors.green,
                ),

                _metric(
                  context,
                  icon: Icons.auto_graph,
                  title: "Avg Confidence",
                  value: "${(averageConfidence * 100).toStringAsFixed(0)}%",
                  color: Colors.deepPurple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
