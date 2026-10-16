import 'package:flutter/material.dart';

class FilterSummary extends StatelessWidget {
  final int filterCount;

  const FilterSummary({super.key, required this.filterCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _metric("Filters", filterCount.toString(), Colors.blue),
            ),
            Expanded(
              child: _metric("Generated", filterCount.toString(), Colors.green),
            ),
            const Expanded(
              child: Text(
                "AI interpreted your natural language into SQL filter conditions.",
                style: TextStyle(color: Colors.grey),
              ),
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
            fontSize: 28,
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
