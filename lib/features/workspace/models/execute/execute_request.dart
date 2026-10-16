class ExecuteRequest {
  final String query;

  ExecuteRequest({required this.query});

  Map<String, dynamic> toJson() {
    return {"query": query};
  }
}
