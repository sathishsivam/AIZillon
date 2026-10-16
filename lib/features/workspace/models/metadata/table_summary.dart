import 'package:flutter/foundation.dart';

@immutable
class TableSummary {
  final int rowCount;
  final int columnCount;
  final int relationshipCount;
  final int businessTermCount;

  const TableSummary({
    required this.rowCount,
    required this.columnCount,
    required this.relationshipCount,
    required this.businessTermCount,
  });
}
