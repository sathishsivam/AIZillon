import 'package:flutter/foundation.dart';
import 'filter_condition.dart';
import '../metadata/metadata_response.dart';
import '../metadata/column_mapping.dart';
import 'package:aizillon/features/workspace/models/parsers/mapping_parser.dart';

class ApproveTableResponse {
  final String status;
  final String sessionId;

  final List<String>? resolvedColumns;

  final List<FilterCondition>? filters;

  final MetadataResponse? metadata;

  final dynamic hitl;
  // final List<ColumnMapping>? columnMappings;
  final List<ColumnMapping> businessMappings;

  ApproveTableResponse({
    required this.status,
    required this.sessionId,
    this.resolvedColumns,
    this.filters,
    this.metadata,
    this.businessMappings = const [],
    this.hitl,
  });

  factory ApproveTableResponse.fromJson(Map<String, dynamic> json) {
    debugPrint("========== APPROVE TABLE RESPONSE ==========");
    debugPrint(json.toString());

    final mappingText = json["runtime_context"]?["mapping_text"];

    debugPrint("========== MAPPING TEXT ==========");
    debugPrint(mappingText?.toString() ?? "NULL");
    debugPrint("==================================");

    return ApproveTableResponse(
      status: json["status"] ?? "",
      sessionId: json["session_id"] ?? "",

      resolvedColumns:
          (json["resolved_columns"] as List?)
              ?.map((e) => e.toString())
              .toList(),

      filters:
          (json["filters"] as List?)
              ?.map((e) => FilterCondition.fromJson(e))
              .toList(),

      metadata:
          json["metadata"] == null
              ? null
              : MetadataResponse.fromJson(json["metadata"]),

      hitl: json["ambiguities"],
      businessMappings: MappingParser.parse(
        json["runtime_context"]?["mapping_text"],
      ),
    );
  }
}
