class ApproveTableRequest {
  final String sessionId;
  final String table;
  final String query;
  final List<String> matchedTerms;

  ApproveTableRequest({
    required this.sessionId,
    required this.table,
    required this.query,
    this.matchedTerms = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      "session_id": sessionId,
      "table": table,
      "query": query,
      "matched_terms": matchedTerms,
    };
  }
}
