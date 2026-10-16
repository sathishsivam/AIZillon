import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/discover/ranked_table.dart';
import '../../models/approve/approve_table_response.dart';

import 'copilot_menu.dart';
import 'copilot_provider.dart';

import 'models/copilot_view.dart';

import 'sections/overview_section.dart';
import 'sections/schema_section.dart';

import 'sections/resolved_columns_section.dart';
import 'sections/filter_section.dart';
import 'sections/business_mapping_section.dart';

class AiCopilotPanel extends ConsumerWidget {
  final RankedTable approvedTable;
  final ApproveTableResponse approveResponse;

  const AiCopilotPanel({
    super.key,
    required this.approvedTable,
    required this.approveResponse,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedView = ref.watch(copilotProvider);

    return Card(
      elevation: 2,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .75,
        child: Row(
          children: [
            Container(
              width: 250,
              color: Colors.grey.shade100,
              child: const CopilotMenu(),
            ),

            const VerticalDivider(width: 1),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildSection(selectedView),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(CopilotView view) {
    switch (view) {
      case CopilotView.overview:
        return OverviewSection(
          approvedTable: approvedTable,
          approveResponse: approveResponse,
        );

      case CopilotView.schema:
        return SchemaSection(
          approvedTable: approvedTable,
          approveResponse: approveResponse,
        );

      case CopilotView.businessMapping:
        return BusinessMappingSection(
          approvedTable: approvedTable,
          approveResponse: approveResponse,
        );

      case CopilotView.resolvedColumns:
        return ResolvedColumnsSection(
          approvedTable: approvedTable,
          approveResponse: approveResponse,
        );

      case CopilotView.filters:
        return FilterSection(
          approvedTable: approvedTable,
          approveResponse: approveResponse,
        );

      case CopilotView.relationships:
        return const Center(
          child: Text(
            "Relationships\n(Coming Next)",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        );

      case CopilotView.sampleData:
        return const Center(
          child: Text(
            "Sample Data\n(Coming Next)",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        );

      case CopilotView.execute:
        return const Center(
          child: Text(
            "Execute SQL\n(Coming Next)",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        );
    }
  }
}
