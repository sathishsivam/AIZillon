import 'package:flutter/material.dart';

import 'package:aizillon/features/workspace/models/metadata/column_mapping.dart';

class BusinessMappingCard extends StatelessWidget {
  final ColumnMapping mapping;

  const BusinessMappingCard({super.key, required this.mapping});

  @override
  Widget build(BuildContext context) {
    final confidence = mapping.confidence.clamp(0.0, 1.0);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.deepPurple.shade50,
                  child: const Icon(Icons.translate, color: Colors.deepPurple),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Business Term",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        mapping.businessTerm,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                _confidenceBadge(confidence),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _mappingBox(
                    context,
                    title: "Business Language",
                    value: mapping.businessTerm,
                    icon: Icons.person_outline,
                  ),
                ),

                const SizedBox(width: 16),

                const Icon(Icons.arrow_forward, color: Colors.deepPurple),

                const SizedBox(width: 16),

                Expanded(
                  child: _mappingBox(
                    context,
                    title: "Database Column",
                    value: mapping.databaseColumn,
                    icon: Icons.storage_outlined,
                  ),
                ),
              ],
            ),

            if (mapping.reason != null &&
                mapping.reason!.trim().isNotEmpty) ...[
              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.psychology_outlined,
                      size: 20,
                      color: Colors.deepPurple,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "AI Reason",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 4),

                          Text(mapping.reason!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _mappingBox(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.blue),

              const SizedBox(width: 8),

              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _confidenceBadge(double confidence) {
    final percentage = (confidence * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: confidence >= 0.8 ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$percentage%",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color:
              confidence >= 0.8
                  ? Colors.green.shade700
                  : Colors.orange.shade700,
        ),
      ),
    );
  }
}
