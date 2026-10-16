import 'package:flutter/material.dart';

import '../../models/discover/ranked_table.dart';
import '../../models/approve/approve_table_response.dart';

// import '../metadata/summary_card.dart';
import '../metadata/filter_card.dart';
import '../metadata/relationship_card.dart';
// import '../metadata/column_dictionary_card.dart';

import 'approval_header.dart';
import 'ai_confidence_bar.dart';
import 'business_term_chips.dart';

class TableSuggestionCard extends StatefulWidget {
  final RankedTable table;

  final bool recommended;

  final bool approved;

  final ApproveTableResponse? approveResponse;

  final VoidCallback onApprove;

  const TableSuggestionCard({
    super.key,
    required this.table,
    required this.recommended,
    required this.onApprove,
    this.approved = false,
    this.approveResponse,
  });

  @override
  State<TableSuggestionCard> createState() => _TableSuggestionCardState();
}

class _TableSuggestionCardState extends State<TableSuggestionCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: widget.approved ? Colors.green : Colors.grey.shade300,
          width: widget.approved ? 2 : 1,
        ),

        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(.05),
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ApprovalHeader(
              tableName: widget.table.table,
              recommended: widget.recommended,
              approved: widget.approved,
            ),

            const SizedBox(height: 20),

            AIConfidenceBar(score: widget.table.score),

            const SizedBox(height: 20),

            const Text(
              "Matched Business Terms",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            BusinessTermChips(terms: widget.table.matchedTerms),

            const SizedBox(height: 20),

            if (!widget.approved)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Approve Table"),
                  onPressed: widget.onApprove,
                ),
              ),

            if (widget.approved && widget.approveResponse != null) ...[
              const Divider(height: 40),

              const Text(
                "Metadata Explorer",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // SummaryCard(),
              const SizedBox(height: 20),

              // ColumnDictionaryCard(
              //   columns: widget.approveResponse!.metadata.columns,
              // ),
              const SizedBox(height: 20),

              FilterCard(filters: widget.approveResponse!.filters ?? []),

              const SizedBox(height: 20),

              RelationshipCard(
                relationships:
                    widget.approveResponse?.metadata?.relationships ?? [],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
