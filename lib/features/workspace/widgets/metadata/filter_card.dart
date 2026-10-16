import 'package:flutter/material.dart';

import '../../models/approve/filter_condition.dart';

class FilterCard extends StatelessWidget {
  final List<FilterCondition> filters;

  const FilterCard({super.key, required this.filters});

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
                Icon(Icons.filter_alt_outlined, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  "Detected Filters",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (filters.isEmpty)
              const Text("No Filters", style: TextStyle(color: Colors.grey))
            else
              ...filters.map(
                (f) => Card(
                  elevation: 0,
                  color: Colors.orange.shade50,
                  child: ListTile(
                    title: Text(f.column),
                    subtitle: Text(f.operator),
                    trailing: Text(
                      "${f.value}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
