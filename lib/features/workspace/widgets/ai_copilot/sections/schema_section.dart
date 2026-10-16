import 'package:flutter/material.dart';

import 'package:aizillon/features/workspace/models/discover/ranked_table.dart';
import 'package:aizillon/features/workspace/models/approve/approve_table_response.dart';

import '../../metadata/metadata_summary_card.dart';

import '../widgets/ai_reason_card.dart';
import '../widgets/column_card.dart';

class SchemaSection extends StatefulWidget {
  final RankedTable approvedTable;
  final ApproveTableResponse approveResponse;

  const SchemaSection({
    super.key,
    required this.approvedTable,
    required this.approveResponse,
  });

  @override
  State<SchemaSection> createState() => _SchemaSectionState();
}

class _SchemaSectionState extends State<SchemaSection> {
  final TextEditingController searchController = TextEditingController();

  bool tableView = false;

  @override
  Widget build(BuildContext context) {
    final columns = widget.approveResponse.metadata?.columns ?? [];

    final filtered =
        columns.where((c) {
          final q = searchController.text.toLowerCase();

          return c.columnName.toLowerCase().contains(q) ||
              c.businessName.toLowerCase().contains(q);
        }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AIReasonCard(approvedTable: widget.approvedTable),

        const SizedBox(height: 24),

        // Existing metadata summary
        // MetadataSummaryCard(metadata: approveResponse.metadata!),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search column...",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),

            const SizedBox(width: 16),

            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.view_agenda_outlined),
                  label: Text("Cards"),
                ),

                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.table_rows_outlined),
                  label: Text("Table"),
                ),
              ],
              selected: {tableView},
              onSelectionChanged: (value) {
                setState(() {
                  tableView = value.first;
                });
              },
            ),
          ],
        ),

        const SizedBox(height: 24),

        Text(
          "${filtered.length} Columns",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        if (!tableView) ...filtered.map((e) => ColumnCard(column: e)),

        if (tableView)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),

              columns: const [
                DataColumn(label: Text("Column")),

                DataColumn(label: Text("Business")),

                DataColumn(label: Text("Datatype")),

                DataColumn(label: Text("PK")),

                DataColumn(label: Text("Nullable")),
              ],

              rows:
                  filtered.map((c) {
                    return DataRow(
                      cells: [
                        DataCell(Text(c.columnName)),

                        DataCell(Text(c.businessName)),

                        DataCell(Text(c.datatype)),

                        DataCell(
                          Icon(
                            c.primaryKey
                                ? Icons.check_circle
                                : Icons.remove_circle_outline,
                            color: c.primaryKey ? Colors.green : Colors.grey,
                          ),
                        ),

                        DataCell(
                          Icon(
                            c.nullable ? Icons.check : Icons.close,
                            color: c.nullable ? Colors.orange : Colors.red,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
      ],
    );
  }
}
