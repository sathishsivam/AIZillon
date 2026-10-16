import 'ranked_table.dart';

class DiscoverTablesResponse {
  final String sessionId;
  final String query;
  final RankedTable suggestion;
  final List<RankedTable> rankedTables;

  const DiscoverTablesResponse({
    required this.sessionId,
    required this.query,
    required this.suggestion,
    required this.rankedTables,
  });

  factory DiscoverTablesResponse.fromJson(Map<String, dynamic> json) {
    return DiscoverTablesResponse(
      sessionId: json["session_id"],
      query: json["query"],
      suggestion: RankedTable.fromJson(json["suggestion"]),
      rankedTables:
          (json["ranked_tables"] as List)
              .map((e) => RankedTable.fromJson(e))
              .toList(),
    );
  }
}
