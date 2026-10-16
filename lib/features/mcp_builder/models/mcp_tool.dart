class McpTool {
  final String id;
  final String name;
  final String description;
  final String method;
  final String path;

  final String transport;
  final String backendType;
  final String baseUrl;
  final String operationId;

  final List<Map<String, dynamic>> parameters;
  final Map<String, dynamic>? requestBody;

  const McpTool({
    required this.id,
    required this.name,
    required this.description,
    required this.method,
    required this.path,
    required this.transport,
    required this.backendType,
    required this.baseUrl,
    required this.operationId,
    required this.parameters,
    required this.requestBody,
  });

  factory McpTool.fromJson(Map<String, dynamic> json) {
    final backend =
        json['backend'] is Map
            ? Map<String, dynamic>.from(json['backend'])
            : <String, dynamic>{};

    final parameters = <Map<String, dynamic>>[];

    if (json['parameters'] is List) {
      for (final parameter in json['parameters']) {
        if (parameter is Map) {
          parameters.add(Map<String, dynamic>.from(parameter));
        }
      }
    }

    Map<String, dynamic>? requestBody;

    if (json['request_body'] is Map) {
      requestBody = Map<String, dynamic>.from(json['request_body']);
    }

    return McpTool(
      id: json['operation_id']?.toString() ?? json['name']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      method: backend['method']?.toString() ?? '',
      path: backend['path']?.toString() ?? '',
      transport: json['transport']?.toString() ?? '',
      backendType: backend['type']?.toString() ?? '',
      baseUrl: backend['base_url']?.toString() ?? '',
      operationId: json['operation_id']?.toString() ?? '',
      parameters: parameters,
      requestBody: requestBody,
    );
  }
}
