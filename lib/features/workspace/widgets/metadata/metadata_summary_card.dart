import 'package:flutter/material.dart';

class MetadataSummaryCard extends StatelessWidget {
  final String tableName;
  final int rowCount;
  final int columnCount;
  final int relationshipCount;
  final int businessTermCount;

  const MetadataSummaryCard({
    super.key,
    required this.tableName,
    required this.rowCount,
    required this.columnCount,
    required this.relationshipCount,
    required this.businessTermCount,
  });

  Widget _metric(String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

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
            Text(
              tableName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                _metric("Rows", rowCount.toString()),
                _metric("Columns", columnCount.toString()),
                _metric("Relations", relationshipCount.toString()),
                _metric("Business Terms", businessTermCount.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
