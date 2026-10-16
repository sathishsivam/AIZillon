import 'dart:convert';

import 'package:http/http.dart' as http;

class McpBuilderService {
  final String baseUrl;

  const McpBuilderService({this.baseUrl = 'http://127.0.0.1:8000'});

  // ============================================================
  // API DISCOVERY
  // ============================================================

  Future<Map<String, dynamic>> discoverApi({required String backendUrl}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api-discovery/discover'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'base_url': backendUrl}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'API discovery failed: '
        '${response.statusCode} ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid API discovery response');
    }

    return decoded;
  }

  // ============================================================
  // BUILD MCP TOOL
  // ============================================================

  Future<Map<String, dynamic>> buildTool({
    required String backendUrl,
    required String path,
    required String method,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api-discovery/build-tool'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'base_url': backendUrl,
        'path': path,
        'method': method,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Failed to build MCP tool: '
        '${response.statusCode} ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid build-tool response');
    }

    return decoded;
  }

  // ============================================================
  // LIST REGISTERED MCP TOOLS
  // ============================================================

  Future<List<Map<String, dynamic>>> getTools() async {
    final response = await http.get(Uri.parse('$baseUrl/api-discovery/tools'));

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load MCP tools: '
        '${response.statusCode} ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid tools response');
    }

    final tools = decoded['tools'];

    if (tools is! List) {
      return [];
    }

    return tools
        .whereType<Map>()
        .map((tool) => Map<String, dynamic>.from(tool))
        .toList();
  }

  // ============================================================
  // EXECUTE MCP TOOL
  // ============================================================

  Future<Map<String, dynamic>> executeTool({
    required String toolName,
    required Map<String, dynamic> arguments,
  }) async {
    final encodedToolName = Uri.encodeComponent(toolName);
    final url = '$baseUrl/api-discovery/execute-tool/$encodedToolName';
    print('EXECUTE TOOL URL: $url');
    print('EXECUTE TOOL ARGUMENTS: $arguments');

    final response = await http.post(
      Uri.parse('$baseUrl/api-discovery/execute-tool/$encodedToolName'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(arguments),
    );
    print('EXECUTE TOOL STATUS: ${response.statusCode}');
    print('EXECUTE TOOL RESPONSE: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Failed to execute MCP tool: '
        '${response.statusCode} ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid tool execution response');
    }

    return decoded;
  }

  // ============================================================
  // EXECUTE REGISTER REST TOOL
  // ============================================================

  Future<Map<String, dynamic>> registerRestTool({
    required String backendUrl,
    required String path,
    required String method,
    String? description,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api-discovery/register-rest-tool'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'base_url': backendUrl,
        'path': path,
        'method': method,
        if (description != null && description.trim().isNotEmpty)
          'description': description.trim(),
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Failed to register REST tool: '
        '${response.statusCode} ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid REST tool registration response');
    }

    return decoded;
  }
}
