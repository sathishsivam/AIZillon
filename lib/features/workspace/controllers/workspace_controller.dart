import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/approve/approve_table_request.dart';
import '../models/discover/discover_tables_request.dart';
import '../models/orchestration/orchestration_request.dart';

import '../repository/workspace_repository.dart';

import 'workspace_state.dart';

class WorkspaceController extends Notifier<WorkspaceState> {
  late final WorkspaceRepository repository;

  @override
  WorkspaceState build() {
    repository = WorkspaceRepository();

    return WorkspaceState.initial();
  }

  // ----------------------------------------------------------------------
  // ASK AIZILLON
  // ----------------------------------------------------------------------

  Future<void> askAizillon(String query) async {
    if (query.trim().isEmpty) {
      return;
    }

    state = state.copyWith(loading: true, query: query, clearError: true);

    try {
      final response = await repository.askAizillon(
        OrchestrationRequest(query: query, sessionId: state.sessionId),
      );

      state = state.copyWith(
        loading: false,
        orchestrationResponse: response,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  // ----------------------------------------------------------------------
  // DISCOVER TABLES
  // ----------------------------------------------------------------------

  Future<void> discoverTables(String query) async {
    if (query.trim().isEmpty) {
      return;
    }

    state = state.copyWith(loading: true, query: query, clearError: true);

    try {
      final response = await repository.discoverTables(
        DiscoverTablesRequest(query: query),
      );

      state = state.copyWith(
        loading: false,
        sessionId: response.sessionId,
        rankedTables: response.rankedTables,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  // ----------------------------------------------------------------------
  // APPROVE TABLE
  // ----------------------------------------------------------------------

  Future<void> approveTable({
    required String table,
    List<String> matchedTerms = const [],
  }) async {
    if (state.sessionId == null) {
      return;
    }

    state = state.copyWith(loading: true, clearError: true);

    try {
      final response = await repository.approveTable(
        ApproveTableRequest(
          sessionId: state.sessionId!,
          table: table,
          query: state.query,
          matchedTerms: matchedTerms,
        ),
      );

      state = state.copyWith(
        loading: false,
        approveResponse: response,
        approvedTable: state.rankedTables.firstWhere((e) => e.table == table),
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  // ----------------------------------------------------------------------
  // CLEAR
  // ----------------------------------------------------------------------

  void clear() {
    state = WorkspaceState.initial();
  }
}
