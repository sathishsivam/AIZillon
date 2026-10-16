import 'package:flutter/material.dart';

class ResolvedColumnsCard extends StatelessWidget {
  final List<String> columns;

  const ResolvedColumnsCard({super.key, required this.columns});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.check_circle_outline, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  "Resolved Columns",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 18),

            if (columns.isEmpty)
              const Text(
                "No columns resolved",
                style: TextStyle(color: Colors.grey),
              )
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    columns
                        .map(
                          (e) => Chip(
                            avatar: const Icon(
                              Icons.done,
                              size: 18,
                              color: Colors.green,
                            ),
                            label: Text(e),
                          ),
                        )
                        .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
