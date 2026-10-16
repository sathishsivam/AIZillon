import 'package:flutter/material.dart';

import '../../models/discover/ranked_table.dart';
import '../../models/approve/approve_table_response.dart';
import 'table_suggestion_card.dart';

class TableSuggestionList extends StatelessWidget {
  final List<RankedTable> tables;

  final RankedTable? approvedTable;

  final ApproveTableResponse? approveResponse;

  final ValueChanged<RankedTable> onApprove;

  const TableSuggestionList({
    super.key,
    required this.tables,
    required this.onApprove,
    this.approvedTable,
    this.approveResponse,
  });

  @override
  Widget build(BuildContext context) {
    if (tables.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tables.length,
      separatorBuilder: (_, __) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        final table = tables[index];

        return TableSuggestionCard(
          table: table,

          recommended: index == 0,

          approved: approvedTable?.table == table.table,

          approveResponse:
              approvedTable?.table == table.table ? approveResponse : null,

          onApprove: () => onApprove(table),
        );
      },
    );
  }
}
