import 'package:flutter/material.dart';
import '../services/mcp_builder_service.dart';
import 'package:go_router/go_router.dart';

class McpServersPage extends StatefulWidget {
  const McpServersPage({super.key});

  @override
  State<McpServersPage> createState() => _McpServersPageState();
}

class _McpServersPageState extends State<McpServersPage> {
  final McpBuilderService _service = const McpBuilderService();

  List<Map<String, dynamic>> _tools = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTools();
  }

  Future<void> _loadTools() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final tools = await _service.getTools();

      if (!mounted) return;

      setState(() {
        _tools = tools;
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

  void _openCreateServer() {
    context.push('/mcp-builder/create').then((_) {
      _loadTools();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MCP Builder',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 8),

            Text(
              'Create and manage MCP servers and tools for AI agents.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MCP Servers',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                Row(
                  children: [
                    IconButton(
                      tooltip: 'Refresh',
                      onPressed: _loading ? null : _loadTools,
                      icon: const Icon(Icons.refresh),
                    ),

                    const SizedBox(width: 8),

                    FilledButton.icon(
                      onPressed: _openCreateServer,
                      icon: const Icon(Icons.add),
                      label: const Text('New Server'),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),

            const SizedBox(height: 12),

            Text(
              'Failed to load MCP tools',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 8),

            Text(_error!, textAlign: TextAlign.center),

            const SizedBox(height: 16),

            FilledButton.icon(
              onPressed: _loadTools,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_tools.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      itemCount: _tools.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _ServerCard(
          tool: _tools[index],
          onTap: () {
            _showToolDetails(_tools[index]);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.hub_outlined, size: 64),

          const SizedBox(height: 16),

          Text(
            'No MCP tools discovered',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 8),

          const Text(
            'Create an MCP server and discover its backend tools.',
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: _openCreateServer,
            icon: const Icon(Icons.add),
            label: const Text('New Server'),
          ),
        ],
      ),
    );
  }

  void _showToolDetails(Map<String, dynamic> tool) {
    context.push('/mcp-builder/tool', extra: tool);
    // final backend = tool['backend'];
    //
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: Text(tool['name']?.toString() ?? 'MCP Tool'),
    //       content: SizedBox(
    //         width: 600,
    //         child: SingleChildScrollView(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               _DetailRow(
    //                 label: 'Description',
    //                 value: tool['description']?.toString() ?? '-',
    //               ),
    //
    //               _DetailRow(
    //                 label: 'Transport',
    //                 value: tool['transport']?.toString() ?? '-',
    //               ),
    //
    //               _DetailRow(
    //                 label: 'Backend',
    //                 value:
    //                     backend is Map
    //                         ? backend['type']?.toString() ?? '-'
    //                         : '-',
    //               ),
    //
    //               _DetailRow(
    //                 label: 'Base URL',
    //                 value:
    //                     backend is Map
    //                         ? backend['base_url']?.toString() ?? '-'
    //                         : '-',
    //               ),
    //
    //               _DetailRow(
    //                 label: 'Path',
    //                 value:
    //                     backend is Map
    //                         ? backend['path']?.toString() ?? '-'
    //                         : '-',
    //               ),
    //
    //               _DetailRow(
    //                 label: 'Method',
    //                 value:
    //                     backend is Map
    //                         ? backend['method']?.toString() ?? '-'
    //                         : '-',
    //               ),
    //
    //               _DetailRow(
    //                 label: 'Operation',
    //                 value: tool['operation_id']?.toString() ?? '-',
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.of(context).pop(),
    //           child: const Text('Close'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }
}

class _ServerCard extends StatelessWidget {
  final Map<String, dynamic> tool;
  final VoidCallback onTap;

  const _ServerCard({required this.tool, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final backend = tool['backend'];

    final String name = tool['name']?.toString() ?? 'Unnamed MCP Tool';

    final String description =
        tool['description']?.toString() ?? 'No description';

    final String transport = tool['transport']?.toString() ?? 'Unknown';

    final String baseUrl =
        backend is Map ? backend['base_url']?.toString() ?? '' : '';

    final String path = backend is Map ? backend['path']?.toString() ?? '' : '';

    final String method =
        backend is Map ? backend['method']?.toString() ?? '' : '';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Icon(Icons.hub_outlined, size: 36),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleMedium),

                    const SizedBox(height: 8),

                    Text(description),

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        _InfoChip(icon: Icons.sync_alt, label: transport),

                        _InfoChip(icon: Icons.http, label: '$method $path'),

                        _InfoChip(icon: Icons.link, label: baseUrl),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              Column(
                children: [
                  const Icon(Icons.circle, size: 12, color: Colors.green),

                  const SizedBox(height: 6),

                  Text('Active', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),

              const SizedBox(width: 16),

              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 16), label: Text(label));
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }
}
