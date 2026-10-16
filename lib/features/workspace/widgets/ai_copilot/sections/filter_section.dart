import 'package:flutter/material.dart';

import '../../../models/discover/ranked_table.dart';
import '../../../models/approve/approve_table_response.dart';

import '../widgets/filter_card.dart';
import '../widgets/filter_summary.dart';

class FilterSection extends StatelessWidget {
  final RankedTable approvedTable;
  final ApproveTableResponse approveResponse;

  const FilterSection({
    super.key,
    required this.approvedTable,
    required this.approveResponse,
  });

  @override
  Widget build(BuildContext context) {
    final filters = approveResponse.filters ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "AI Generated Filters",
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        const SizedBox(height: 8),

        const Text(
          "The Intelligence Layer converted your natural language into SQL filter conditions.",
        ),

        const SizedBox(height: 24),

        FilterSummary(filterCount: filters.length),

        const SizedBox(height: 24),

        ...filters.map((filter) => FilterCard(filter: filter)),
      ],
    );
  }
}
