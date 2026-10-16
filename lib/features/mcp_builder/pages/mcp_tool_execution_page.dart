import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/mcp_tool.dart';
import '../services/mcp_builder_service.dart';

class McpToolExecutionPage extends StatefulWidget {
  final McpTool tool;

  const McpToolExecutionPage({super.key, required this.tool});

  @override
  State<McpToolExecutionPage> createState() => _McpToolExecutionPageState();
}

class _McpToolExecutionPageState extends State<McpToolExecutionPage> {
  final TextEditingController _queryController = TextEditingController();

  final McpBuilderService _service = const McpBuilderService();

  bool _executing = false;

  Map<String, dynamic>? _result;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _executeTool() async {
    final query = _queryController.text.trim();

    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a query')));
      return;
    }

    setState(() {
      _executing = true;
      _result = null;
    });

    try {
      final result = await _service.executeTool(
        toolName: widget.tool.name,
        arguments: {'query': query},
      );

      if (!mounted) return;

      setState(() {
        _result = result;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _result = {'status': 'ERROR', 'message': e.toString()};
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tool execution failed: $e')));
    } finally {
      if (!mounted) return;

      setState(() {
        _executing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final McpTool tool = widget.tool;

    return Scaffold(
      appBar: AppBar(title: Text(tool.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, tool),

                const SizedBox(height: 24),

                _buildApiInformation(context, tool),

                const SizedBox(height: 24),

                _buildRequestSection(context),

                if (_result != null) ...[
                  const SizedBox(height: 24),
                  _buildResultSection(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, McpTool tool) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tool.name, style: Theme.of(context).textTheme.headlineMedium),

        const SizedBox(height: 8),

        Text(
          tool.description.isEmpty ? 'MCP tool' : tool.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildApiInformation(BuildContext context, McpTool tool) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'API Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Chip(
                  avatar: const Icon(Icons.http, size: 18),
                  label: Text(tool.method.toUpperCase()),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: SelectableText(
                    tool.path.isEmpty ? '/' : tool.path,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),

            if (tool.id.isNotEmpty) ...[
              const SizedBox(height: 16),

              Text('Tool ID', style: Theme.of(context).textTheme.labelLarge),

              const SizedBox(height: 6),

              SelectableText(
                tool.id,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRequestSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Request', style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 8),

            Text(
              'Provide the request that will be '
              'passed to the MCP tool.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _queryController,
              maxLines: 5,
              enabled: !_executing,
              decoration: const InputDecoration(
                labelText: 'Query',
                hintText: 'Example: find ATM locations in Tamil Nadu',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed:
                      _executing
                          ? null
                          : () {
                            _queryController.clear();

                            setState(() {
                              _result = null;
                            });
                          },
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),

                const SizedBox(width: 12),

                FilledButton.icon(
                  onPressed: _executing ? null : _executeTool,
                  icon:
                      _executing
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.play_arrow),
                  label: Text(_executing ? 'Executing...' : 'Execute Tool'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection(BuildContext context) {
    final bool hasError = _result?['status'] == 'ERROR';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasError ? Icons.error_outline : Icons.check_circle_outline,
                ),

                const SizedBox(width: 10),

                Text(
                  hasError ? 'Tool Execution Error' : 'Tool Result',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: SelectableText(
                _formatResult(_result!),
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatResult(Map<String, dynamic> result) {
    try {
      return const JsonEncoder.withIndent('  ').convert(result);
    } catch (_) {
      return result.toString();
    }
  }
}
