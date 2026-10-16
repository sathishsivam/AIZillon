import 'package:flutter/foundation.dart';

@immutable
class ColumnMapping {
  final String businessTerm;
  final String databaseColumn;

  final double confidence;

  final String? reason;

  const ColumnMapping({
    required this.businessTerm,
    required this.databaseColumn,
    this.confidence = 1.0,
    this.reason,
  });
}
