import 'package:flutter/foundation.dart';

@immutable
class ColumnMetadata {
  final String columnName;
  final String businessName;
  final String datatype;
  final bool nullable;
  final bool primaryKey;

  const ColumnMetadata({
    required this.columnName,
    required this.businessName,
    required this.datatype,
    required this.nullable,
    required this.primaryKey,
  });

  factory ColumnMetadata.fromJson(Map<String, dynamic> json) {
    return ColumnMetadata(
      columnName: json["column_name"],
      businessName: json["business_name"],
      datatype: json["datatype"],
      nullable: json["nullable"],
      primaryKey: json["primary_key"],
    );
  }
}
