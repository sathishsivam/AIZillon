import 'column_metadata.dart';
import 'relationship.dart';

class MetadataResponse {
  final String table;

  final int rowCount;

  final int columnCount;

  final int relationshipCount;

  final int businessTermCount;

  final List<ColumnMetadata> columns;

  final List<Relationship> relationships;

  MetadataResponse({
    required this.table,
    required this.rowCount,
    required this.columnCount,
    required this.relationshipCount,
    required this.businessTermCount,
    required this.columns,
    required this.relationships,
  });

  factory MetadataResponse.fromJson(Map<String, dynamic> json) {
    final summary = json["summary"] ?? {};

    return MetadataResponse(
      table: summary["table_name"] ?? "",

      rowCount: summary["row_count"] ?? 0,

      columnCount: summary["column_count"] ?? 0,

      relationshipCount: summary["relationship_count"] ?? 0,

      businessTermCount: summary["business_term_count"] ?? 0,

      columns:
          (json["columns"] as List? ?? [])
              .map((e) => ColumnMetadata.fromJson(e))
              .toList(),

      relationships:
          (json["relationships"] as List? ?? [])
              .map((e) => Relationship.fromJson(e))
              .toList(),
    );
  }
}
