// import 'package:flutter/material.dart';
//
// import 'package:aizillon/features/workspace/models/discover/ranked_table.dart';
// import 'package:aizillon/features/workspace/models/approve/approve_table_response.dart';
//
// import '../widgets/business_mapping_card.dart';
// import '../widgets/mapping_summary_card.dart';

// class BusinessMappingSection extends StatelessWidget {
//   final RankedTable approvedTable;
//   final ApproveTableResponse approveResponse;
//
//   const BusinessMappingSection({
//     super.key,
//     required this.approvedTable,
//     required this.approveResponse,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final mappings = approveResponse.businessMappings;
//
//     if (mappings.isEmpty) {
//       return const Center(child: Text("No business mappings available"));
//     }
//
//     final averageConfidence =
//         mappings.map((mapping) => mapping.confidence).reduce((a, b) => a + b) /
//         mappings.length;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Business Mapping",
//           style: Theme.of(context).textTheme.headlineSmall,
//         ),
//
//         const SizedBox(height: 8),
//
//         const Text(
//           "The Intelligence Layer translated business language into physical database columns.",
//         ),
//
//         const SizedBox(height: 24),
//
//         MappingSummaryCard(
//           tableName: approvedTable.table,
//           detectedTerms: mappings.length,
//           mappedColumns: mappings.length,
//           averageConfidence: averageConfidence,
//         ),
//
//         const SizedBox(height: 24),
//
//         ...mappings.map((mapping) => BusinessMappingCard(mapping: mapping)),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'package:aizillon/features/workspace/models/discover/ranked_table.dart';
import 'package:aizillon/features/workspace/models/approve/approve_table_response.dart';

class BusinessMappingSection extends StatelessWidget {
  final RankedTable approvedTable;
  final ApproveTableResponse approveResponse;

  const BusinessMappingSection({
    super.key,
    required this.approvedTable,
    required this.approveResponse,
  });

  @override
  Widget build(BuildContext context) {
    final mappings = approveResponse.businessMappings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Business Mapping",
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        const SizedBox(height: 20),

        Text(
          "Approved table: ${approvedTable.table}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        Text(
          "Mappings received: ${mappings.length}",
          style: const TextStyle(fontSize: 16),
        ),

        const SizedBox(height: 20),

        if (mappings.isEmpty) const Text("No business mappings available"),

        ...mappings.map(
          (mapping) => ListTile(
            leading: const Icon(Icons.arrow_forward),
            title: Text(mapping.businessTerm),
            subtitle: Text(mapping.databaseColumn),
          ),
        ),
      ],
    );
  }
}
