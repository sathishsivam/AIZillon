import 'package:flutter/material.dart';

import '../services/mcp_builder_service.dart';

class CreateMcpServerPage extends StatefulWidget {
  const CreateMcpServerPage({super.key});

  @override
  State<CreateMcpServerPage> createState() => _CreateMcpServerPageState();
}

class _CreateMcpServerPageState extends State<CreateMcpServerPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _portController = TextEditingController(text: '8001');

  final _baseUrlController = TextEditingController(
    text: 'http://127.0.0.1:8000',
  );

  final _endpointPathController = TextEditingController();
  final _endpointDescriptionController = TextEditingController();

  final McpBuilderService _service = const McpBuilderService();

  String _transport = 'Streamable HTTP';
  String _backendType = 'REST API';
  String _connectionMode = 'API Discovery';
  String _httpMethod = 'GET';

  bool _discovering = false;
  bool _building = false;
  bool _registering = false;
  bool _executing = false;

  Map<String, dynamic>? _discoveryResult;

  List<Map<String, dynamic>> _endpoints = [];

  Map<String, dynamic>? _selectedEndpoint;

  Map<String, dynamic>? _generatedTool;

  /*
   * IMPORTANT
   *
   * Controller keys are now location-aware.
   *
   * Example:
   *
   * path:id
   * query:id
   * header:id
   * body:id
   *
   * This prevents a path parameter "id" and a query parameter
   * "id" from sharing the same TextEditingController.
   */
  Map<String, TextEditingController> _requestControllers = {};

  Map<String, dynamic>? _toolResult;

  // ============================================================
  // PARAMETER CONTROLLER KEY
  // ============================================================

  String _parameterKey(String name, {String? location}) {
    final normalizedLocation =
        (location == null || location.isEmpty) ? 'body' : location;

    return '$normalizedLocation:$name';
  }

  // ============================================================
  // PARAMETER LOCATION
  // ============================================================

  String _parameterLocation(Map<String, dynamic> parameter) {
    final location = parameter['in']?.toString();

    if (location != null && location.isNotEmpty) {
      return location;
    }

    final location2 = parameter['location']?.toString();

    if (location2 != null && location2.isNotEmpty) {
      return location2;
    }

    return 'query';
  }

  // ============================================================
  // DISCOVER BACKEND APIs
  // ============================================================

  Future<void> _discoverApis() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_backendType != 'REST API') {
      _showMessage(
        'Currently API discovery is supported for REST APIs.',
        isError: true,
      );
      return;
    }

    final baseUrl = _baseUrlController.text.trim();

    setState(() {
      _discovering = true;
      _building = false;
      _registering = false;
      _executing = false;

      _discoveryResult = null;
      _endpoints = [];
      _selectedEndpoint = null;
      _generatedTool = null;
      _toolResult = null;
    });

    _disposeRequestControllers();

    try {
      final result = await _service.discoverApi(backendUrl: baseUrl);

      final discoveredEndpoints = result['endpoints'];

      final parsedEndpoints = <Map<String, dynamic>>[];

      if (discoveredEndpoints is List) {
        for (final endpoint in discoveredEndpoints) {
          if (endpoint is Map) {
            parsedEndpoints.add(Map<String, dynamic>.from(endpoint));
          }
        }
      }

      if (!mounted) return;

      setState(() {
        _discoveryResult = result;
        _endpoints = parsedEndpoints;
        _discovering = false;
      });

      if (parsedEndpoints.isEmpty) {
        _showMessage('No supported APIs were discovered.', isError: true);
      } else {
        _showMessage('${parsedEndpoints.length} API endpoint(s) discovered.');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _discovering = false;
      });

      _showMessage('API discovery failed: $e', isError: true);
    }
  }

  // ============================================================
  // REGISTER MANUAL REST ENDPOINT
  // ============================================================

  Future<void> _registerRestEndpoint() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final endpointUrl = _baseUrlController.text.trim();

    final path = _endpointPathController.text.trim();

    if (path.isEmpty) {
      _showMessage('REST endpoint path is required.', isError: true);
      return;
    }

    if (!path.startsWith('/')) {
      _showMessage('REST endpoint path must start with "/".', isError: true);
      return;
    }

    final parsedUri = Uri.tryParse(endpointUrl);

    if (parsedUri == null || !parsedUri.hasScheme || parsedUri.host.isEmpty) {
      _showMessage('Enter a valid backend base URL.', isError: true);
      return;
    }

    setState(() {
      _registering = true;
      _generatedTool = null;
      _toolResult = null;
    });

    _disposeRequestControllers();

    try {
      final tool = await _service.registerRestTool(
        backendUrl: endpointUrl,
        path: path,
        method: _httpMethod,
        description:
            _endpointDescriptionController.text.trim().isEmpty
                ? _descriptionController.text.trim()
                : _endpointDescriptionController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _generatedTool = tool;
        _registering = false;
      });

      _initializeRequestFields(tool);

      _showMessage('REST MCP tool registered successfully.');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _registering = false;
      });

      _showMessage('REST tool registration failed: $e', isError: true);
    }
  }

  // ============================================================
  // BUILD MCP TOOL FROM DISCOVERED ENDPOINT
  // ============================================================

  Future<void> _buildSelectedTool() async {
    final endpoint = _selectedEndpoint;

    if (endpoint == null) {
      _showMessage('Select an API endpoint first.', isError: true);
      return;
    }

    final path = endpoint['path']?.toString();

    final method = endpoint['method']?.toString();

    if (path == null || path.isEmpty) {
      _showMessage(
        'Selected API does not contain a valid path.',
        isError: true,
      );
      return;
    }

    if (method == null || method.isEmpty) {
      _showMessage(
        'Selected API does not contain a valid HTTP method.',
        isError: true,
      );
      return;
    }

    setState(() {
      _building = true;
      _generatedTool = null;
      _toolResult = null;
    });

    _disposeRequestControllers();

    try {
      final tool = await _service.buildTool(
        backendUrl: _baseUrlController.text.trim(),
        path: path,
        method: method,
      );

      if (!mounted) return;

      setState(() {
        _generatedTool = tool;
        _building = false;
      });

      _initializeRequestFields(tool);

      _showMessage('MCP tool created successfully.');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _building = false;
      });

      _showMessage('Failed to build MCP tool: $e', isError: true);
    }
  }

  // ============================================================
  // INITIALIZE REQUEST FIELDS
  // ============================================================

  void _initializeRequestFields(Map<String, dynamic> tool) {
    _disposeRequestControllers();

    final controllers = <String, TextEditingController>{};

    /*
     * ----------------------------------------------------------
     * 1. OpenAPI / REST parameters
     *
     * Example:
     *
     * {
     *   "name": "id",
     *   "in": "path"
     * }
     *
     * controller key:
     *
     * path:id
     *
     * ----------------------------------------------------------
     */

    final parameters = tool['parameters'];

    if (parameters is List) {
      for (final parameter in parameters) {
        if (parameter is! Map) {
          continue;
        }

        final definition = Map<String, dynamic>.from(parameter);

        final name = definition['name']?.toString() ?? '';

        if (name.isEmpty) {
          continue;
        }

        final location = _parameterLocation(definition);

        final key = _parameterKey(name, location: location);

        String initialValue = '';

        final schema =
            definition['schema'] is Map
                ? Map<String, dynamic>.from(definition['schema'])
                : <String, dynamic>{};

        if (schema.containsKey('default')) {
          initialValue = schema['default']?.toString() ?? '';
        }

        controllers[key] = TextEditingController(text: initialValue);
      }
    }

    /*
     * ----------------------------------------------------------
     * 2. Request body parameters
     *
     * Body fields are stored as:
     *
     * body:fieldName
     *
     * ----------------------------------------------------------
     */

    final schema = _getRequestSchema(tool);

    if (schema != null) {
      final properties = schema['properties'];

      if (properties is Map) {
        for (final entry in properties.entries) {
          final name = entry.key.toString();

          String initialValue = '';

          final property = entry.value;

          if (property is Map && property.containsKey('default')) {
            initialValue = property['default']?.toString() ?? '';
          }

          final key = _parameterKey(name, location: 'body');

          controllers[key] = TextEditingController(text: initialValue);
        }
      }
    }

    setState(() {
      _requestControllers = controllers;
    });
  }

  // ============================================================
  // GET REQUEST SCHEMA
  // ============================================================

  Map<String, dynamic>? _getRequestSchema(Map<String, dynamic> tool) {
    final requestBody = tool['request_body'];

    if (requestBody is! Map) {
      return null;
    }

    final content = requestBody['content'];

    if (content is! Map || content.isEmpty) {
      return null;
    }

    Map<String, dynamic>? selectedContent;

    final jsonContent = content['application/json'];

    if (jsonContent is Map) {
      selectedContent = Map<String, dynamic>.from(jsonContent);
    } else {
      final first = content.values.first;

      if (first is Map) {
        selectedContent = Map<String, dynamic>.from(first);
      }
    }

    if (selectedContent == null) {
      return null;
    }

    final schema = selectedContent['schema'];

    if (schema is! Map) {
      return null;
    }

    return Map<String, dynamic>.from(schema);
  }

  // ============================================================
  // EXECUTE GENERATED MCP TOOL
  // ============================================================

  Future<void> _executeGeneratedTool() async {
    final tool = _generatedTool;

    if (tool == null) {
      return;
    }

    final toolName = tool['name']?.toString();

    if (toolName == null || toolName.isEmpty) {
      _showMessage(
        'Generated tool does not contain a tool name.',
        isError: true,
      );
      return;
    }

    final arguments = <String, dynamic>{};

    /*
     * ----------------------------------------------------------
     * Collect API parameters
     * ----------------------------------------------------------
     */

    final parameters = tool['parameters'];

    if (parameters is List) {
      for (final parameter in parameters) {
        if (parameter is! Map) {
          continue;
        }

        final definition = Map<String, dynamic>.from(parameter);

        final name = definition['name']?.toString() ?? '';

        if (name.isEmpty) {
          continue;
        }

        final location = _parameterLocation(definition);

        final controllerKey = _parameterKey(name, location: location);

        final controller = _requestControllers[controllerKey];

        final value = controller?.text.trim() ?? '';

        final required = definition['required'] == true;

        if (required && value.isEmpty) {
          _showMessage('$name ($location) is required.', isError: true);
          return;
        }

        if (value.isNotEmpty) {
          final schema =
              definition['schema'] is Map
                  ? Map<String, dynamic>.from(definition['schema'])
                  : definition;

          arguments[name] = _convertValue(value, schema);
        }
      }
    }

    /*
     * ----------------------------------------------------------
     * Collect request body fields
     * ----------------------------------------------------------
     */

    final schema = _getRequestSchema(tool);

    if (schema != null) {
      final properties = schema['properties'];

      final requiredFields =
          schema['required'] is List
              ? (schema['required'] as List).map((e) => e.toString()).toSet()
              : <String>{};

      if (properties is Map) {
        for (final entry in properties.entries) {
          final name = entry.key.toString();

          final controllerKey = _parameterKey(name, location: 'body');

          final controller = _requestControllers[controllerKey];

          final value = controller?.text.trim() ?? '';

          if (requiredFields.contains(name) && value.isEmpty) {
            _showMessage('$name is required.', isError: true);
            return;
          }

          if (value.isNotEmpty) {
            arguments[name] = _convertValue(value, entry.value);
          }
        }
      }
    }

    setState(() {
      _executing = true;
      _toolResult = null;
    });

    try {
      final result = await _service.executeTool(
        toolName: toolName,
        arguments: arguments,
      );

      if (!mounted) return;

      setState(() {
        _toolResult = result;
        _executing = false;
      });

      _showMessage('MCP tool executed successfully.');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _executing = false;
        _toolResult = {'error': e.toString()};
      });

      _showMessage('Tool execution failed: $e', isError: true);
    }
  }

  // ============================================================
  // CONVERT REQUEST VALUE
  // ============================================================

  dynamic _convertValue(String value, dynamic propertyDefinition) {
    if (propertyDefinition is! Map) {
      return value;
    }

    final type = propertyDefinition['type']?.toString();

    switch (type) {
      case 'integer':
        return int.tryParse(value) ?? value;

      case 'number':
        return double.tryParse(value) ?? value;

      case 'boolean':
        return value.toLowerCase() == 'true';

      case 'array':
        return value
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList();

      case 'object':
        return value;

      default:
        return value;
    }
  }

  // ============================================================
  // DISPOSE REQUEST CONTROLLERS
  // ============================================================

  void _disposeRequestControllers() {
    for (final controller in _requestControllers.values) {
      controller.dispose();
    }

    _requestControllers = {};
  }

  // ============================================================
  // FINISH
  // ============================================================

  void _finish() {
    Navigator.of(context).pop(true);
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // ============================================================
  // BUILD UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create MCP Server')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create MCP Server',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Connect to a backend API and expose '
                    'its operations as MCP tools for AI agents.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 32),

                  _buildServerConfiguration(),

                  const SizedBox(height: 24),

                  _buildBackendConnection(),

                  const SizedBox(height: 24),

                  if (_connectionMode == 'API Discovery')
                    _buildDiscoverySection()
                  else
                    _buildRestEndpointSection(),

                  if (_connectionMode == 'API Discovery' &&
                      _endpoints.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildDiscoveredApis(),
                  ],

                  if (_generatedTool != null) ...[
                    const SizedBox(height: 24),
                    _buildGeneratedTool(),
                  ],

                  const SizedBox(height: 32),

                  _buildBottomActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SERVER CONFIGURATION
  // ============================================================

  Widget _buildServerConfiguration() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Server Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 24),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Server Name',
                hintText: 'Banking MCP Server',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Server name is required';
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Banking operations exposed to AI agents',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _transport,
              decoration: const InputDecoration(
                labelText: 'Transport',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Streamable HTTP',
                  child: Text('Streamable HTTP'),
                ),
                DropdownMenuItem(value: 'SSE', child: Text('SSE')),
                DropdownMenuItem(value: 'STDIO', child: Text('STDIO')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _transport = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'MCP Server Port',
                hintText: '8001',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final port = int.tryParse(value ?? '');

                if (port == null || port < 1 || port > 65535) {
                  return 'Enter a valid port';
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BACKEND CONNECTION
  // ============================================================

  Widget _buildBackendConnection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Backend Connection',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 8),

            Text(
              'Choose how the MCP Builder should '
              'connect to the backend.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            DropdownButtonFormField<String>(
              value: _backendType,
              decoration: const InputDecoration(
                labelText: 'Backend Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'REST API', child: Text('REST API')),
                DropdownMenuItem(value: 'JEE', child: Text('JEE')),
                DropdownMenuItem(value: 'SOAP', child: Text('SOAP')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _backendType = value;
                    _clearBackendState();
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _connectionMode,
              decoration: const InputDecoration(
                labelText: 'Connection Mode',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'API Discovery',
                  child: Text('API Discovery'),
                ),
                DropdownMenuItem(
                  value: 'REST Endpoint',
                  child: Text('REST Endpoint'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _connectionMode = value;
                    _clearBackendState();
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _baseUrlController,
              decoration: InputDecoration(
                labelText: 'Backend Base URL',
                hintText: 'https://example.com',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.link),
                helperText:
                    _connectionMode == 'REST Endpoint'
                        ? 'Enter the API base URL. '
                            'The endpoint path is entered below.'
                        : 'Enter the backend API base URL.',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Base URL is required';
                }

                final uri = Uri.tryParse(value.trim());

                if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
                  return 'Enter a valid URL';
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // REST ENDPOINT SECTION
  // ============================================================

  Widget _buildRestEndpointSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.http, size: 28),
                const SizedBox(width: 12),
                Text(
                  'REST Endpoint',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              'Register a REST endpoint directly. '
              'This is useful when the backend does not '
              'provide an OpenAPI specification.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            TextFormField(
              controller: _endpointPathController,
              decoration: const InputDecoration(
                labelText: 'Endpoint Path',
                hintText: '/posts',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.route),
                helperText: 'Example: /posts or /accounts/101',
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _httpMethod,
              decoration: const InputDecoration(
                labelText: 'HTTP Method',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'GET', child: Text('GET')),
                DropdownMenuItem(value: 'POST', child: Text('POST')),
                DropdownMenuItem(value: 'PUT', child: Text('PUT')),
                DropdownMenuItem(value: 'PATCH', child: Text('PATCH')),
                DropdownMenuItem(value: 'DELETE', child: Text('DELETE')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _httpMethod = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _endpointDescriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Endpoint Description',
                hintText: 'Get posts from the backend',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _registering ? null : _registerRestEndpoint,
                icon:
                    _registering
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.add_link),
                label: Text(
                  _registering ? 'Registering...' : 'Register REST Tool',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CLEAR BACKEND STATE
  // ============================================================

  void _clearBackendState() {
    _discoveryResult = null;
    _endpoints = [];
    _selectedEndpoint = null;
    _generatedTool = null;
    _toolResult = null;

    _disposeRequestControllers();
  }

  // ============================================================
  // DISCOVERY SECTION
  // ============================================================

  Widget _buildDiscoverySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.travel_explore, size: 28),
                const SizedBox(width: 12),
                Text(
                  'API Discovery',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              'The MCP Builder reads the backend '
              'OpenAPI specification and discovers '
              'available API operations automatically.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: _discovering ? null : _discoverApis,
              icon:
                  _discovering
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.search),
              label: Text(
                _discovering ? 'Discovering APIs...' : 'Discover APIs',
              ),
            ),

            if (_discoveryResult != null) ...[
              const SizedBox(height: 20),
              _buildDiscoverySummary(),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DISCOVERY SUMMARY
  // ============================================================

  Widget _buildDiscoverySummary() {
    final result = _discoveryResult!;

    final title = result['title']?.toString() ?? 'Backend API';

    final version = result['version']?.toString() ?? '-';

    final openApiVersion = result['openapi_version']?.toString() ?? '-';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 12,
        children: [
          _summaryItem('API', title),
          _summaryItem('Version', version),
          _summaryItem('OpenAPI', openApiVersion),
          _summaryItem('Endpoints', _endpoints.length.toString()),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  // ============================================================
  // DISCOVERED APIs
  // ============================================================

  Widget _buildDiscoveredApis() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discovered APIs',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 8),

            Text(
              'Select an operation to expose it '
              'as an MCP tool.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 20),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _endpoints.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildEndpointCard(_endpoints[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ENDPOINT CARD
  // ============================================================

  Widget _buildEndpointCard(Map<String, dynamic> endpoint) {
    final isSelected = identical(_selectedEndpoint, endpoint);

    final method = endpoint['method']?.toString() ?? '';

    final path = endpoint['path']?.toString() ?? '';

    final summary = endpoint['summary']?.toString() ?? '';

    final description = endpoint['description']?.toString() ?? '';

    final operationId = endpoint['operation_id']?.toString() ?? '';

    final tags =
        endpoint['tags'] is List
            ? (endpoint['tags'] as List).map((e) => e.toString()).toList()
            : <String>[];

    return Card(
      elevation: isSelected ? 3 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outlineVariant,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _selectedEndpoint = endpoint;
            _generatedTool = null;
            _toolResult = null;
          });

          _disposeRequestControllers();
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio<Map<String, dynamic>>(
                value: endpoint,
                groupValue: _selectedEndpoint,
                onChanged: (value) {
                  setState(() {
                    _selectedEndpoint = value;
                    _generatedTool = null;
                    _toolResult = null;
                  });

                  _disposeRequestControllers();
                },
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Chip(label: Text(method)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            path,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (summary.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        summary,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],

                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if (operationId.isNotEmpty)
                          Chip(
                            avatar: const Icon(Icons.terminal, size: 16),
                            label: Text(operationId),
                          ),
                        ...tags.map((tag) => Chip(label: Text(tag))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // GENERATED TOOL
  // ============================================================

  Widget _buildGeneratedTool() {
    final tool = _generatedTool!;

    final backend = tool['backend'];

    final backendMap =
        backend is Map
            ? Map<String, dynamic>.from(backend)
            : <String, dynamic>{};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 28),
                const SizedBox(width: 12),
                Text(
                  'MCP Tool Generated',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),

            const SizedBox(height: 24),

            _detail('Tool Name', tool['name']?.toString() ?? '-'),

            _detail('Description', tool['description']?.toString() ?? '-'),

            _detail('Transport', tool['transport']?.toString() ?? '-'),

            _detail('Backend', backendMap['type']?.toString() ?? '-'),

            _detail('Base URL', backendMap['base_url']?.toString() ?? '-'),

            _detail('Path', backendMap['path']?.toString() ?? '-'),

            _detail('Method', backendMap['method']?.toString() ?? '-'),

            _detail('Operation ID', tool['operation_id']?.toString() ?? '-'),

            const SizedBox(height: 16),

            _buildRequestSection(),

            if (_toolResult != null) ...[
              const SizedBox(height: 24),
              _buildToolResult(),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // REQUEST SECTION
  // ============================================================

  Widget _buildRequestSection() {
    final tool = _generatedTool!;

    final parameters = tool['parameters'];

    final schema = _getRequestSchema(tool);

    final hasParameters = parameters is List && parameters.isNotEmpty;

    final properties = schema?['properties'];

    final hasBodyProperties = properties is Map && properties.isNotEmpty;

    final requiredBodyFields =
        schema?['required'] is List
            ? (schema!['required'] as List).map((e) => e.toString()).toSet()
            : <String>{};

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Request', style: Theme.of(context).textTheme.titleMedium),

          const SizedBox(height: 8),

          Text(
            'Request fields are generated '
            'automatically from the API schema.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 20),

          if (hasParameters) ...[_buildParameterGroups(parameters)],

          if (hasParameters && hasBodyProperties) const SizedBox(height: 24),

          if (hasBodyProperties) ...[
            Text('Request Body', style: Theme.of(context).textTheme.titleSmall),

            const SizedBox(height: 12),

            ...properties.entries.map((entry) {
              final name = entry.key.toString();

              final definition =
                  entry.value is Map
                      ? Map<String, dynamic>.from(entry.value)
                      : <String, dynamic>{};

              return _buildRequestField(
                name,
                definition,
                requiredBodyFields.contains(name),
                location: 'body',
              );
            }),
          ],

          if (!hasParameters && !hasBodyProperties)
            const Text(
              'This API does not define '
              'request parameters or a request body schema.',
            ),

          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _executing ? null : _executeGeneratedTool,
              icon:
                  _executing
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.play_arrow),
              label: Text(_executing ? 'Executing...' : 'Test Tool'),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PARAMETER GROUPS
  // ============================================================

  Widget _buildParameterGroups(dynamic parameters) {
    final grouped = <String, List<Map<String, dynamic>>>{
      'path': [],
      'query': [],
      'header': [],
      'cookie': [],
    };

    if (parameters is List) {
      for (final parameter in parameters) {
        if (parameter is! Map) {
          continue;
        }

        final definition = Map<String, dynamic>.from(parameter);

        final location = _parameterLocation(definition);

        grouped.putIfAbsent(location, () => []);

        grouped[location]!.add(definition);
      }
    }

    final widgets = <Widget>[];

    final order = ['path', 'query', 'header', 'cookie'];

    for (final location in order) {
      final items = grouped[location] ?? [];

      if (items.isEmpty) {
        continue;
      }

      widgets.add(_buildParameterGroup(location, items));

      widgets.add(const SizedBox(height: 20));
    }

    for (final entry in grouped.entries) {
      if (order.contains(entry.key) || entry.value.isEmpty) {
        continue;
      }

      widgets.add(_buildParameterGroup(entry.key, entry.value));

      widgets.add(const SizedBox(height: 20));
    }

    if (widgets.isNotEmpty) {
      widgets.removeLast();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  // ============================================================
  // PARAMETER GROUP
  // ============================================================

  Widget _buildParameterGroup(
    String location,
    List<Map<String, dynamic>> parameters,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_parameterLocationIcon(location), size: 20),
              const SizedBox(width: 8),
              Text(
                _parameterLocationTitle(location),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),

          const SizedBox(height: 14),

          ...parameters.map((parameter) {
            final name = parameter['name']?.toString() ?? '';

            final schema =
                parameter['schema'] is Map
                    ? Map<String, dynamic>.from(parameter['schema'])
                    : <String, dynamic>{};

            final type = schema['type']?.toString() ?? 'string';

            final description = parameter['description']?.toString();

            final required = parameter['required'] == true;

            final enumValues = schema['enum'];

            final definition = <String, dynamic>{
              ...schema,
              if (description != null) 'description': description,
            };

            if (enumValues is List && enumValues.isNotEmpty) {
              return _buildEnumParameterField(
                name,
                definition,
                required,
                location,
                enumValues,
              );
            }

            return _buildRequestField(
              name,
              definition,
              required,
              location: location,
            );
          }),
        ],
      ),
    );
  }

  // ============================================================
  // REQUEST FIELD
  // ============================================================

  Widget _buildRequestField(
    String name,
    Map<String, dynamic> definition,
    bool required, {
    required String location,
  }) {
    final type = definition['type']?.toString() ?? 'string';

    final description = definition['description']?.toString();

    final controllerKey = _parameterKey(name, location: location);

    final controller = _requestControllers[controllerKey];

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: _keyboardTypeFor(type),
        maxLines:
            type == 'string' && description != null && description.length > 100
                ? 3
                : 1,
        decoration: InputDecoration(
          labelText: required ? '$name *' : name,
          helperText: description ?? 'Location: $location | Type: $type',
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  // ============================================================
  // ENUM PARAMETER FIELD
  // ============================================================

  Widget _buildEnumParameterField(
    String name,
    Map<String, dynamic> definition,
    bool required,
    String location,
    List enumValues,
  ) {
    final controllerKey = _parameterKey(name, location: location);

    final controller = _requestControllers[controllerKey];

    final currentValue =
        controller?.text.isNotEmpty == true ? controller!.text : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: DropdownButtonFormField<String>(
        value: enumValues.contains(currentValue) ? currentValue : null,
        decoration: InputDecoration(
          labelText: required ? '$name *' : name,
          helperText: definition['description']?.toString(),
          border: const OutlineInputBorder(),
        ),
        items:
            enumValues.map((value) {
              return DropdownMenuItem<String>(
                value: value.toString(),
                child: Text(value.toString()),
              );
            }).toList(),
        onChanged: (value) {
          controller?.text = value ?? '';

          setState(() {});
        },
      ),
    );
  }

  // ============================================================
  // PARAMETER LOCATION TITLE
  // ============================================================

  String _parameterLocationTitle(String location) {
    switch (location) {
      case 'path':
        return 'Path Parameters';

      case 'query':
        return 'API / Query Parameters';

      case 'header':
        return 'Header Parameters';

      case 'cookie':
        return 'Cookie Parameters';

      default:
        return '${location[0].toUpperCase()}'
            '${location.substring(1)} Parameters';
    }
  }

  // ============================================================
  // PARAMETER LOCATION ICON
  // ============================================================

  IconData _parameterLocationIcon(String location) {
    switch (location) {
      case 'path':
        return Icons.route;

      case 'query':
        return Icons.manage_search;

      case 'header':
        return Icons.http;

      case 'cookie':
        return Icons.cookie;

      default:
        return Icons.tune;
    }
  }

  // ============================================================
  // KEYBOARD TYPE
  // ============================================================

  TextInputType _keyboardTypeFor(String type) {
    switch (type) {
      case 'integer':
        return TextInputType.number;

      case 'number':
        return const TextInputType.numberWithOptions(decimal: true);

      case 'boolean':
        return TextInputType.text;

      default:
        return TextInputType.text;
    }
  }

  // ============================================================
  // TOOL RESULT
  // ============================================================

  Widget _buildToolResult() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.output),
              const SizedBox(width: 8),
              Text(
                'Tool Result',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),

          const SizedBox(height: 16),

          SelectableText(
            _formatResult(_toolResult!),
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FORMAT RESULT
  // ============================================================

  String _formatResult(Map<String, dynamic> result) {
    try {
      return _prettyFormat(result, 0);
    } catch (_) {
      return result.toString();
    }
  }

  String _prettyFormat(dynamic value, int indent) {
    final spaces = ' ' * indent;

    if (value is Map) {
      final buffer = StringBuffer();

      value.forEach((key, child) {
        buffer.writeln('$spaces$key:');

        buffer.write(_prettyFormat(child, indent + 2));
      });

      return buffer.toString();
    }

    if (value is List) {
      final buffer = StringBuffer();

      for (final item in value) {
        buffer.writeln(
          '$spaces- '
          '${_valueToString(item)}',
        );
      }

      return buffer.toString();
    }

    return '$spaces'
        '${_valueToString(value)}\n';
  }

  String _valueToString(dynamic value) {
    if (value is Map || value is List) {
      return value.toString();
    }

    return value?.toString() ?? 'null';
  }

  // ============================================================
  // BOTTOM ACTIONS
  // ============================================================

  Widget _buildBottomActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed:
              _discovering || _building || _registering || _executing
                  ? null
                  : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),

        const SizedBox(width: 12),

        if (_connectionMode == 'API Discovery' &&
            _selectedEndpoint != null &&
            _generatedTool == null)
          FilledButton.icon(
            onPressed: _building ? null : _buildSelectedTool,
            icon:
                _building
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.build),
            label: Text(_building ? 'Building Tool...' : 'Build MCP Tool'),
          ),

        if (_generatedTool != null)
          FilledButton.icon(
            onPressed: _executing ? null : _finish,
            icon: const Icon(Icons.check),
            label: const Text('Done'),
          ),
      ],
    );
  }

  // ============================================================
  // DETAIL
  // ============================================================

  Widget _detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _portController.dispose();
    _baseUrlController.dispose();
    _endpointPathController.dispose();
    _endpointDescriptionController.dispose();

    for (final controller in _requestControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }
}
