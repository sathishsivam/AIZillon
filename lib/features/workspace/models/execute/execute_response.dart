class ExecuteResponse {
  final String sql;

  final List<dynamic> data;

  ExecuteResponse({required this.sql, required this.data});

  factory ExecuteResponse.fromJson(Map<String, dynamic> json) {
    return ExecuteResponse(sql: json["sql"] ?? "", data: json["data"] ?? []);
  }
}
