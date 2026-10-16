import 'package:flutter/material.dart';

import 'package:aizillon/features/workspace/models/metadata/column_metadata.dart';

class ColumnCard extends StatelessWidget {
  final ColumnMetadata column;

  const ColumnCard({super.key, required this.column});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  column.primaryKey ? Icons.key : Icons.view_column,
                  color: column.primaryKey ? Colors.orange : Colors.blue,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    column.columnName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Chip(label: Text(column.datatype)),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              "Business Name",
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 4),

            Text(
              column.businessName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              children: [
                Chip(
                  avatar: Icon(
                    column.nullable ? Icons.check : Icons.close,
                    size: 16,
                  ),
                  label: Text(column.nullable ? "Nullable" : "Mandatory"),
                ),

                if (column.primaryKey)
                  const Chip(
                    avatar: Icon(Icons.key, size: 16),
                    label: Text("Primary Key"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
