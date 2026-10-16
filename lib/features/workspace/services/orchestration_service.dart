import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/orchestration_models.dart';

class OrchestrationService {
  final String baseUrl;

  const OrchestrationService({this.baseUrl = 'http://127.0.0.1:8000'});

  Future<OrchestrationResponse> orchestrate(
    OrchestrationRequest request,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orchestrate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Orchestration failed: '
        '${response.statusCode} ${response.body}',
      );
    }

    final json = jsonDecode(response.body);

    if (json is! Map<String, dynamic>) {
      throw Exception('Invalid orchestration response');
    }

    return OrchestrationResponse.fromJson(json);
  }
}
