import 'package:flutter/material.dart';

import '../../../models/metadata/column_metadata.dart';

class ResolvedColumnCard extends StatelessWidget {
  final ColumnMetadata column;
  final bool usedInFilter;

  const ResolvedColumnCard({
    super.key,
    required this.column,
    required this.usedInFilter,
  });

  String get reason {
    if (usedInFilter) {
      return "Used for filtering and query output";
    }

    return "Selected by Intelligence Layer";
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
              column.businessName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              column.columnName,
              style: TextStyle(color: Colors.grey.shade700),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                Chip(label: Text(column.datatype)),

                if (column.primaryKey) const Chip(label: Text("Primary Key")),

                if (usedInFilter)
                  const Chip(
                    backgroundColor: Color(0xffFFF3E0),
                    label: Text("Filter Column"),
                  ),
              ],
            ),

            const SizedBox(height: 16),

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
                  Expanded(child: Text(reason)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
