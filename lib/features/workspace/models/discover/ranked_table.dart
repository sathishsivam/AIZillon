class RankedTable {
  final String table;
  final double score;
  final List<String> matchedTerms;

  const RankedTable({
    required this.table,
    required this.score,
    required this.matchedTerms,
  });

  factory RankedTable.fromJson(Map<String, dynamic> json) {
    return RankedTable(
      table: json["table"],
      score: (json["score"] as num).toDouble(),
      matchedTerms: List<String>.from(json["matched_terms"] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {"table": table, "score": score, "matched_terms": matchedTerms};
  }
}
