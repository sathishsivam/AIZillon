import 'package:flutter/material.dart';

import '../services/mcp_builder_service.dart';

class ApiDiscoveryPage extends StatefulWidget {
  final String baseUrl;

  const ApiDiscoveryPage({super.key, required this.baseUrl});

  @override
  State<ApiDiscoveryPage> createState() => _ApiDiscoveryPageState();
}

class _ApiDiscoveryPageState extends State<ApiDiscoveryPage> {
  final McpBuilderService _service = const McpBuilderService();

  bool _loading = false;
  String? _error;

  Map<String, dynamic>? _discoveryResult;

  List<Map<String, dynamic>> _endpoints = [];

  @override
  void initState() {
    super.initState();
    _discoverApis();
  }

  Future<void> _discoverApis() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await _service.discoverApi(backendUrl: widget.baseUrl);

      if (!mounted) return;

      final endpoints = result['endpoints'];

      setState(() {
        _discoveryResult = result;

        if (endpoints is List) {
          _endpoints =
              endpoints
                  .whereType<Map>()
                  .map((endpoint) => Map<String, dynamic>.from(endpoint))
                  .toList();
        } else {
          _endpoints = [];
        }

        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Discovery'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loading ? null : _discoverApis,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),

            const SizedBox(height: 24),

            Expanded(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final title = _discoveryResult?['title']?.toString() ?? 'Backend API';

    final version = _discoveryResult?['version']?.toString() ?? '-';

    final openApiVersion =
        _discoveryResult?['openapi_version']?.toString() ?? '-';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.manage_search, size: 32),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'API Discovery',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Discover APIs from the backend OpenAPI specification.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                FilledButton.icon(
                  onPressed: _loading ? null : _discoverApis,
                  icon: const Icon(Icons.search),
                  label: const Text('Discover APIs'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Divider(),

            const SizedBox(height: 16),

            _buildInfoRow('Base URL', widget.baseUrl),

            const SizedBox(height: 8),

            _buildInfoRow('API Title', title),

            const SizedBox(height: 8),

            _buildInfoRow('Version', version),

            const SizedBox(height: 8),

            _buildInfoRow('OpenAPI', openApiVersion),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        Expanded(
          child: SelectableText(
            value,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),

            SizedBox(height: 16),

            Text('Discovering backend APIs...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return _buildError(context);
    }

    if (_discoveryResult == null) {
      return _buildInitialState(context);
    }

    if (_endpoints.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Discovered APIs',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(width: 12),

            Chip(label: Text('${_endpoints.length}')),
          ],
        ),

        const SizedBox(height: 16),

        Expanded(
          child: ListView.separated(
            itemCount: _endpoints.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _ApiEndpointCard(
                endpoint: _endpoints[index],
                baseUrl: widget.baseUrl,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return const Center(
      child: Text('Click "Discover APIs" to inspect the backend.'),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.api_outlined, size: 64),

          const SizedBox(height: 16),

          Text(
            'No APIs discovered',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 8),

          const Text(
            'The backend OpenAPI specification contains no supported endpoints.',
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: _discoverApis,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),

              const SizedBox(height: 16),

              Text(
                'API discovery failed',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: 700,
                child: SelectableText(_error!, textAlign: TextAlign.center),
              ),

              const SizedBox(height: 20),

              FilledButton.icon(
                onPressed: _discoverApis,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApiEndpointCard extends StatelessWidget {
  final Map<String, dynamic> endpoint;
  final String baseUrl;

  const _ApiEndpointCard({required this.endpoint, required this.baseUrl});

  @override
  Widget build(BuildContext context) {
    final method = endpoint['method']?.toString() ?? '';

    final path = endpoint['path']?.toString() ?? '';

    final summary = endpoint['summary']?.toString() ?? '';

    final description = endpoint['description']?.toString() ?? '';

    final operationId = endpoint['operation_id']?.toString() ?? '';

    final tags = endpoint['tags'];

    final parameters = endpoint['parameters'];

    final requestBody = endpoint['request_body'];

    final security = endpoint['security'];

    final displayDescription =
        description.isNotEmpty
            ? description
            : summary.isNotEmpty
            ? summary
            : 'No description available';

    return Card(
      child: InkWell(
        onTap: () {
          _showEndpointDetails(context, endpoint);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MethodBadge(method: method),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      path,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      displayDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (operationId.isNotEmpty)
                          Chip(
                            avatar: const Icon(Icons.label_outline, size: 16),
                            label: Text(operationId),
                          ),

                        if (tags is List && tags.isNotEmpty)
                          Chip(
                            avatar: const Icon(Icons.sell_outlined, size: 16),
                            label: Text(
                              tags.map((e) => e.toString()).join(', '),
                            ),
                          ),

                        if (parameters is List && parameters.isNotEmpty)
                          Chip(
                            avatar: const Icon(Icons.input, size: 16),
                            label: Text('${parameters.length} parameters'),
                          ),

                        if (requestBody != null)
                          const Chip(
                            avatar: Icon(Icons.data_object, size: 16),
                            label: Text('Request Body'),
                          ),

                        if (security is List && security.isNotEmpty)
                          const Chip(
                            avatar: Icon(Icons.lock_outline, size: 16),
                            label: Text('Secured'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              Column(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      _showEndpointDetails(context, endpoint);
                    },
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Details'),
                  ),

                  const SizedBox(height: 8),

                  FilledButton.icon(
                    onPressed: () {
                      _showBuildToolDialog(context, endpoint, baseUrl);
                    },
                    icon: const Icon(Icons.build_outlined),
                    label: const Text('Build Tool'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEndpointDetails(
    BuildContext context,
    Map<String, dynamic> endpoint,
  ) {
    final method = endpoint['method']?.toString() ?? '';

    final path = endpoint['path']?.toString() ?? '';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            '$method $path',
            style: const TextStyle(fontFamily: 'monospace'),
          ),
          content: SizedBox(
            width: 800,
            child: SingleChildScrollView(child: _JsonSection(data: endpoint)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showBuildToolDialog(
    BuildContext context,
    Map<String, dynamic> endpoint,
    String baseUrl,
  ) {
    final method = endpoint['method']?.toString() ?? '';

    final path = endpoint['path']?.toString() ?? '';

    final operationId = endpoint['operation_id']?.toString() ?? '';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Build MCP Tool'),
          content: SizedBox(
            width: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'The selected API will be converted into an MCP tool.',
                ),

                const SizedBox(height: 20),

                _BuildInfoRow(label: 'Base URL', value: baseUrl),

                _BuildInfoRow(label: 'Method', value: method),

                _BuildInfoRow(label: 'Path', value: path),

                _BuildInfoRow(
                  label: 'Operation ID',
                  value: operationId.isEmpty ? '-' : operationId,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),

            FilledButton.icon(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                try {
                  final service = const McpBuilderService();

                  final result = await service.buildTool(
                    backendUrl: baseUrl,
                    path: path,
                    method: method,
                  );

                  if (!context.mounted) {
                    return;
                  }

                  _showBuildSuccess(context, result);
                } catch (e) {
                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to build MCP tool: $e')),
                  );
                }
              },
              icon: const Icon(Icons.build),
              label: const Text('Build Tool'),
            ),
          ],
        );
      },
    );
  }

  void _showBuildSuccess(BuildContext context, Map<String, dynamic> result) {
    final toolName =
        result['name']?.toString() ??
        result['operation_id']?.toString() ??
        'MCP Tool';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('MCP Tool Created'),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(child: _JsonSection(data: result)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Close'),
            ),

            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Done: $toolName'),
            ),
          ],
        );
      },
    );
  }
}

class _MethodBadge extends StatelessWidget {
  final String method;

  const _MethodBadge({required this.method});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(),
      ),
      child: Center(
        child: Text(
          method.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}

class _BuildInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _BuildInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}

class _JsonSection extends StatelessWidget {
  final Map<String, dynamic> data;

  const _JsonSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      _prettyJson(data),
      style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
    );
  }

  String _prettyJson(Map<String, dynamic> data) {
    try {
      return _formatValue(data);
    } catch (_) {
      return data.toString();
    }
  }

  String _formatValue(dynamic value, [int indent = 0]) {
    final spaces = '  ' * indent;

    if (value is Map) {
      final buffer = StringBuffer();

      buffer.writeln('{');

      final entries = value.entries.toList();

      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];

        buffer.write('$spaces  "${entry.key}": ');

        buffer.write(_formatValue(entry.value, indent + 1));

        if (i < entries.length - 1) {
          buffer.write(',');
        }

        buffer.writeln();
      }

      buffer.write('$spaces}');

      return buffer.toString();
    }

    if (value is List) {
      if (value.isEmpty) {
        return '[]';
      }

      final buffer = StringBuffer();

      buffer.writeln('[');

      for (var i = 0; i < value.length; i++) {
        buffer.write('${'  ' * (indent + 1)}');

        buffer.write(_formatValue(value[i], indent + 1));

        if (i < value.length - 1) {
          buffer.write(',');
        }

        buffer.writeln();
      }

      buffer.write('${'  ' * indent}]');

      return buffer.toString();
    }

    if (value == null) {
      return 'null';
    }

    if (value is String) {
      return '"$value"';
    }

    return value.toString();
  }
}
