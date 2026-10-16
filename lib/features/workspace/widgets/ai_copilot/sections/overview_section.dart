import 'package:flutter/material.dart';

import '../../../models/discover/ranked_table.dart';
import '../../../models/approve/approve_table_response.dart';

import '../widgets/summary_tile.dart';
import '../widgets/info_card.dart';
import '../widgets/metadata_chip.dart';
import '../widgets/section_title.dart';

class OverviewSection extends StatelessWidget {
  final RankedTable approvedTable;
  final ApproveTableResponse approveResponse;

  const OverviewSection({
    super.key,
    required this.approvedTable,
    required this.approveResponse,
  });

  @override
  Widget build(BuildContext context) {
    final metadata = approveResponse.metadata;

    final totalColumns = metadata?.columns.length ?? 0;
    final totalRelations = metadata?.relationships.length ?? 0;
    final totalFilters = approveResponse.filters?.length ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const SectionTitle("Overview"),

          const SizedBox(height: 20),

          Text(
            approvedTable.table,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            childAspectRatio: 2.5,

            children: [
              SummaryTile(
                title: "Columns",
                value: "$totalColumns",
                icon: Icons.view_column,
                color: Colors.blue,
              ),

              SummaryTile(
                title: "Relationships",
                value: "$totalRelations",
                icon: Icons.account_tree,
                color: Colors.green,
              ),

              SummaryTile(
                title: "Filters",
                value: "$totalFilters",
                icon: Icons.filter_alt,
                color: Colors.orange,
              ),

              SummaryTile(
                title: "Confidence",
                value: "${(approvedTable.score * 100).toStringAsFixed(0)}%",
                icon: Icons.auto_awesome,
                color: Colors.purple,
              ),
            ],
          ),

          const SizedBox(height: 30),

          InfoCard(
            title: "AI Summary",
            icon: Icons.psychology,
            description:
                "This table has been selected as the best candidate for your query based on semantic similarity, metadata matching, and business terminology.",
          ),

          const SizedBox(height: 30),

          const Text(
            "Matched Business Terms",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 14),

          Wrap(
            children:
                approvedTable.matchedTerms
                    .map((e) => MetadataChip(text: e))
                    .toList(),
          ),

          const SizedBox(height: 30),

          InfoCard(
            title: "Recommended Next Step",
            icon: Icons.lightbulb,
            description:
                "Explore the schema to understand available columns before generating SQL.",
          ),
        ],
      ),
    );
  }
}
