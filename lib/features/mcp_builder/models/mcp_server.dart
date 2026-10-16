class McpServer {
  final String id;
  final String name;
  final String description;
  final String transport;
  final int port;
  final bool enabled;
  final int toolCount;
  final String backendType;
  final String baseUrl;

  const McpServer({
    required this.id,
    required this.name,
    required this.description,
    required this.transport,
    required this.port,
    required this.enabled,
    required this.toolCount,
    required this.backendType,
    required this.baseUrl,
  });
}
