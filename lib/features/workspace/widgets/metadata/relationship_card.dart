import 'package:flutter/material.dart';
import '../../models/metadata/relationship.dart';

class RelationshipCard extends StatelessWidget {
  final List<Relationship> relationships;

  const RelationshipCard({super.key, required this.relationships});

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
            const Row(
              children: [
                Icon(Icons.account_tree_outlined, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text(
                  "Relationships",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (relationships.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "No Relationships Found",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Text(
                "${relationships.length} relationship(s) available",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
          ],
        ),
      ),
    );
  }
}
