import 'package:aizillon/features/workspace/models/metadata/column_mapping.dart';

class MappingParser {
  static List<ColumnMapping> parse(String? mappingText) {
    if (mappingText == null || mappingText.trim().isEmpty) {
      return [];
    }

    final mappings = <ColumnMapping>[];

    final lines = mappingText.split('\n');

    for (final line in lines) {
      if (!line.contains('→')) continue;

      final parts = line.split('→');
      if (parts.length != 2) continue;

      final businessTerm =
          parts[0].replaceAll('-', '').replaceAll('"', '').trim();

      final databaseColumn = parts[1].trim();

      mappings.add(
        ColumnMapping(
          businessTerm: businessTerm,
          databaseColumn: databaseColumn,
        ),
      );
    }

    return mappings;
  }
}
