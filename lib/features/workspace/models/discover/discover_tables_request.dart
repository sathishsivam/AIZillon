class DiscoverTablesRequest {
  final String query;

  const DiscoverTablesRequest({required this.query});

  Map<String, dynamic> toJson() {
    return {"query": query};
  }
}
