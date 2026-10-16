import 'package:flutter/material.dart';

import 'package:aizillon/features/workspace/models/discover/ranked_table.dart';
import 'package:aizillon/features/workspace/models/approve/approve_table_response.dart';

import '../widgets/resolved_column_card.dart';
import '../widgets/resolved_column_summary.dart';

class ResolvedColumnsSection extends StatelessWidget {
  final RankedTable approvedTable;
  final ApproveTableResponse approveResponse;

  const ResolvedColumnsSection({
    super.key,
    required this.approvedTable,
    required this.approveResponse,
  });

  @override
  Widget build(BuildContext context) {
    final metadata = approveResponse.metadata;

    if (metadata == null) {
      return const Center(child: Text("No metadata available"));
    }

    final resolved = approveResponse.resolvedColumns ?? [];

    final columns =
        metadata.columns.where((c) => resolved.contains(c.columnName)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "AI Selected Columns",
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        const SizedBox(height: 8),

        const Text(
          "These columns were selected by the Intelligence Layer for SQL generation.",
        ),

        const SizedBox(height: 24),

        ResolvedColumnSummary(
          totalColumns: metadata.columns.length,
          resolvedColumns: columns.length,
        ),

        const SizedBox(height: 24),

        Column(
          children:
              columns.map((column) {
                final usedInFilter =
                    approveResponse.filters?.any(
                      (f) => f.column == column.columnName,
                    ) ??
                    false;

                return ResolvedColumnCard(
                  column: column,
                  usedInFilter: usedInFilter,
                );
              }).toList(),
        ),
      ],
    );
  }
}
