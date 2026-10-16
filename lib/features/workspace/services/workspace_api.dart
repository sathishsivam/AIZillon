import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

import '../models/discover/discover_tables_request.dart';
import '../models/discover/discover_tables_response.dart';

import '../models/approve/approve_table_request.dart';
import '../models/approve/approve_table_response.dart';

import '../models/orchestration/orchestration_request.dart';
import '../models/orchestration/orchestration_response.dart';

class WorkspaceApi {
  final Dio _dio = ApiClient.dio;

  // -------------------------------------------------------
  // Ask AIZillon / Orchestration
  // -------------------------------------------------------

  Future<OrchestrationResponse> askAizillon(
    OrchestrationRequest request,
  ) async {
    final response = await _dio.post(
      "/orchestration/execute",
      data: request.toJson(),

      // ---------------------------------------------------
      // Orchestration may involve Ollama + planner + RAG
      // and can currently take longer than the normal API
      // timeout.
      // ---------------------------------------------------
      options: Options(
        receiveTimeout: const Duration(minutes: 5),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    return OrchestrationResponse.fromJson(response.data);
  }

  // -------------------------------------------------------
  // Discover Tables
  // -------------------------------------------------------

  Future<DiscoverTablesResponse> discoverTables(
    DiscoverTablesRequest request,
  ) async {
    final response = await _dio.post(
      "/discover_tables",
      data: request.toJson(),
    );

    return DiscoverTablesResponse.fromJson(response.data);
  }

  // -------------------------------------------------------
  // Approve Table
  // -------------------------------------------------------

  Future<ApproveTableResponse> approveTable(ApproveTableRequest request) async {
    final response = await _dio.post("/approve_table", data: request.toJson());

    print("========== APPROVE TABLE RESPONSE ==========");
    print(response.data);
    print("============================================");

    try {
      return ApproveTableResponse.fromJson(response.data);
    } catch (e, s) {
      print("MODEL PARSE ERROR");
      print(e);
      print(s);
      rethrow;
    }
  }
}
