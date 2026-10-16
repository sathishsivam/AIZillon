class FilterCondition {
  final String column;
  final String operator;

  final dynamic value;

  final List<dynamic>? values;

  const FilterCondition({
    required this.column,
    required this.operator,
    this.value,
    this.values,
  });

  factory FilterCondition.fromJson(Map<String, dynamic> json) {
    return FilterCondition(
      column: json["column"]?.toString() ?? "",
      operator: json["operator"]?.toString() ?? "=",
      value: json["value"],
      values:
          json["values"] == null ? null : List<dynamic>.from(json["values"]),
    );
  }

  /// Always returns a list of values
  List<dynamic> get allValues {
    if (values != null && values!.isNotEmpty) {
      return values!;
    }

    if (value != null) {
      return [value];
    }

    return [];
  }

  /// SQL preview
  String get sqlPreview {
    if (operator.toUpperCase() == "IN") {
      return "$column IN (${allValues.join(", ")})";
    }

    if (allValues.isEmpty) {
      return "$column $operator";
    }

    return "$column $operator ${allValues.first}";
  }
}
