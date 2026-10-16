import 'package:flutter/material.dart';

import '../../../models/approve/filter_condition.dart';

class FilterCard extends StatelessWidget {
  final FilterCondition filter;

  const FilterCard({super.key, required this.filter});

  String get explanation {
    switch (filter.operator.toUpperCase()) {
      case "IN":
        return "Multiple values detected from the user's request.";
      case "=":
        return "Exact value match requested.";
      case "LIKE":
        return "Partial text search detected.";
      default:
        return "Generated automatically by the Intelligence Layer.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              filter.column,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              children: [Chip(label: Text("Operator : ${filter.operator}"))],
            ),

            const SizedBox(height: 16),

            const Text("Values", style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  filter.allValues
                      .map(
                        (v) => Chip(
                          backgroundColor: Colors.orange.shade50,
                          label: Text(v.toString()),
                        ),
                      )
                      .toList(),
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.orange),
                  const SizedBox(width: 10),
                  Expanded(child: Text(explanation)),
                ],
              ),
            ),

            const SizedBox(height: 14),

            SelectableText(
              "${filter.column} ${filter.operator} (${filter.allValues.join(", ")})",
              style: const TextStyle(fontFamily: "monospace"),
            ),
          ],
        ),
      ),
    );
  }
}
