import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/workspace_provider.dart';

import 'metadata_summary_card.dart';
import 'resolved_columns_card.dart';
import 'filter_card.dart';
import 'relationship_card.dart';

class MetadataPanel extends ConsumerWidget {
  const MetadataPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workspaceControllerProvider);

    final response = state.approveResponse;

    if (response == null || response.metadata == null) {
      return const SizedBox();
    }

    final metadata = response.metadata!;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MetadataSummaryCard(
                tableName: metadata.table,
                rowCount: metadata.rowCount,
                columnCount: metadata.columnCount,
                relationshipCount: metadata.relationshipCount,
                businessTermCount: metadata.businessTermCount,
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: ResolvedColumnsCard(
                columns: response.resolvedColumns ?? [],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: FilterCard(filters: response.filters ?? [])),

            const SizedBox(width: 20),

            Expanded(
              child: RelationshipCard(relationships: metadata.relationships),
            ),
          ],
        ),
      ],
    );
  }
}
