import 'package:flutter/foundation.dart';

import '../models/approve/approve_table_response.dart';
import '../models/discover/ranked_table.dart';
import '../models/orchestration/orchestration_response.dart';

@immutable
class WorkspaceState {
  final bool loading;

  final String query;

  final String? sessionId;

  final List<RankedTable> rankedTables;

  final String? error;

  /// Complete response from /approve_table
  final ApproveTableResponse? approveResponse;

  /// Selected table
  final RankedTable? approvedTable;

  /// Response from the AIZillon orchestration layer
  final OrchestrationResponse? orchestrationResponse;

  const WorkspaceState({
    this.loading = false,
    this.query = '',
    this.sessionId,
    this.rankedTables = const [],
    this.error,
    this.approveResponse,
    this.approvedTable,
    this.orchestrationResponse,
  });

  WorkspaceState copyWith({
    bool? loading,
    String? query,
    String? sessionId,
    List<RankedTable>? rankedTables,
    String? error,
    bool clearError = false,
    ApproveTableResponse? approveResponse,
    RankedTable? approvedTable,
    OrchestrationResponse? orchestrationResponse,
  }) {
    return WorkspaceState(
      loading: loading ?? this.loading,
      query: query ?? this.query,
      sessionId: sessionId ?? this.sessionId,
      rankedTables: rankedTables ?? this.rankedTables,
      error: clearError ? null : (error ?? this.error),
      approveResponse: approveResponse ?? this.approveResponse,
      approvedTable: approvedTable ?? this.approvedTable,
      orchestrationResponse:
          orchestrationResponse ?? this.orchestrationResponse,
    );
  }

  factory WorkspaceState.initial() {
    return const WorkspaceState();
  }
}
