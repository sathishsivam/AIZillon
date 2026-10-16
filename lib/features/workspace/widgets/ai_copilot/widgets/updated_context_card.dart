import 'package:flutter/material.dart';

class UpdatedContextCard extends StatelessWidget {
  final List<String> resolvedColumns;
  final int filterCount;

  const UpdatedContextCard({
    super.key,
    required this.resolvedColumns,
    required this.filterCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.auto_awesome, color: Colors.white),
                ),

                const SizedBox(width: 12),

                Text(
                  "Execution Context Updated",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Resolved Columns",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  resolvedColumns
                      .map(
                        (e) => Chip(
                          avatar: const Icon(
                            Icons.check,
                            size: 18,
                            color: Colors.green,
                          ),
                          label: Text(e),
                        ),
                      )
                      .toList(),
            ),

            const SizedBox(height: 20),

            Text(
              "Filters Applied : $filterCount",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "The Intelligence Layer has incorporated your decision. SQL generation can now proceed with the updated execution context.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
