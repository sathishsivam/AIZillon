import 'package:flutter/foundation.dart';

@immutable
class Relationship {
  final String table;
  final String type;

  const Relationship({required this.table, required this.type});

  factory Relationship.fromJson(Map<String, dynamic> json) {
    return Relationship(table: json["table"], type: json["type"]);
  }
}
