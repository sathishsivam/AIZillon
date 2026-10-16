import 'package:flutter/material.dart';

class ResolvedColumnSummary extends StatelessWidget {
  final int totalColumns;
  final int resolvedColumns;

  const ResolvedColumnSummary({
    super.key,
    required this.totalColumns,
    required this.resolvedColumns,
  });

  @override
  Widget build(BuildContext context) {
    final removed = totalColumns - resolvedColumns;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _metric("Available", totalColumns.toString(), Colors.blue),
            ),
            Expanded(
              child: _metric(
                "Selected",
                resolvedColumns.toString(),
                Colors.green,
              ),
            ),
            Expanded(
              child: _metric("Ignored", removed.toString(), Colors.orange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Text(title),
      ],
    );
  }
}
