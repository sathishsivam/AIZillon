import '../models/discover/discover_tables_request.dart';
import '../models/discover/discover_tables_response.dart';

import '../models/approve/approve_table_request.dart';
import '../models/approve/approve_table_response.dart';

import '../models/orchestration/orchestration_request.dart';
import '../models/orchestration/orchestration_response.dart';

import '../services/workspace_api.dart';

class WorkspaceRepository {
  final WorkspaceApi _api = WorkspaceApi();

  // -------------------------------------------------------
  // Ask AIZillon
  // -------------------------------------------------------

  Future<OrchestrationResponse> askAizillon(OrchestrationRequest request) {
    return _api.askAizillon(request);
  }

  // -------------------------------------------------------
  // Discover Tables
  // -------------------------------------------------------

  Future<DiscoverTablesResponse> discoverTables(DiscoverTablesRequest request) {
    return _api.discoverTables(request);
  }

  // -------------------------------------------------------
  // Approve Table
  // -------------------------------------------------------

  Future<ApproveTableResponse> approveTable(ApproveTableRequest request) {
    return _api.approveTable(request);
  }
}
