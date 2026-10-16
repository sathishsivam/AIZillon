import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/workspace_provider.dart';
import '../models/discover/ranked_table.dart';
import '../widgets/discover/table_suggestion_list.dart';
import '../widgets/query/prompt_input.dart';
import '../widgets/ai_copilot/ai_copilot_panel.dart';

class WorkspacePage extends ConsumerWidget {
  const WorkspacePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workspaceControllerProvider);

    final orchestrationResponse = state.orchestrationResponse;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------------
          // PAGE TITLE
          // ---------------------------------------------------------
          const Text(
            "AI Workspace",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          // ---------------------------------------------------------
          // ASK AIZILLON AI
          // ---------------------------------------------------------
          const PromptInput(),

          // ---------------------------------------------------------
          // ORCHESTRATION RESPONSE
          // ---------------------------------------------------------
          if (orchestrationResponse != null) ...[
            const SizedBox(height: 24),

            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -------------------------------------------------
                    // RESPONSE HEADER
                    // -------------------------------------------------
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, size: 22),

                        const SizedBox(width: 8),

                        const Text(
                          "AIZillon",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        if (orchestrationResponse.strategy != null)
                          _StrategyChip(
                            strategy: orchestrationResponse.strategy!,
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // -------------------------------------------------
                    // ACTUAL RESPONSE
                    // -------------------------------------------------
                    if (orchestrationResponse.response != null &&
                        orchestrationResponse.response!.trim().isNotEmpty)
                      SelectableText(
                        orchestrationResponse.response!,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),

                    // -------------------------------------------------
                    // FALLBACK INFORMATION
                    // -------------------------------------------------
                    if (orchestrationResponse.response == null ||
                        orchestrationResponse.response!.trim().isEmpty) ...[
                      _InfoRow(
                        label: "Intent",
                        value: orchestrationResponse.intent ?? "-",
                      ),

                      const SizedBox(height: 8),

                      _InfoRow(
                        label: "Strategy",
                        value: orchestrationResponse.strategy ?? "-",
                      ),
                    ],

                    // -------------------------------------------------
                    // AUTHENTICATION
                    // -------------------------------------------------
                    if (orchestrationResponse.requiresAuthentication) ...[
                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange.withValues(alpha: 0.10),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.35),
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.lock_outline, color: Colors.orange),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Authentication is required to continue.",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // -------------------------------------------------
                    // CONFIRMATION
                    // -------------------------------------------------
                    if (orchestrationResponse.requiresConfirmation) ...[
                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue.withValues(alpha: 0.08),
                          border: Border.all(
                            color: Colors.blue.withValues(alpha: 0.30),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.help_outline, color: Colors.blue),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Confirmation required",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  if (orchestrationResponse
                                          .clarificationQuestion !=
                                      null) ...[
                                    const SizedBox(height: 6),

                                    Text(
                                      orchestrationResponse
                                          .clarificationQuestion!,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],

                                  if (orchestrationResponse.confirmationId !=
                                      null) ...[
                                    const SizedBox(height: 6),

                                    Text(
                                      "Confirmation ID: "
                                      "${orchestrationResponse.confirmationId}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // -------------------------------------------------
                    // CLARIFICATION QUESTION
                    // -------------------------------------------------
                    if (!orchestrationResponse.requiresConfirmation &&
                        orchestrationResponse.clarificationQuestion !=
                            null) ...[
                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withValues(alpha: 0.08),
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.question_mark),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                orchestrationResponse.clarificationQuestion!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // -------------------------------------------------
                    // SOURCES
                    // -------------------------------------------------
                    if (orchestrationResponse.sources.isNotEmpty) ...[
                      const SizedBox(height: 24),

                      const Divider(),

                      const SizedBox(height: 16),

                      const Row(
                        children: [
                          Icon(Icons.source_outlined),
                          SizedBox(width: 8),
                          Text(
                            "Sources",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      ...orchestrationResponse.sources.map(
                        (source) => _SourceCard(
                          type: source.type,
                          name: source.name,
                          metadata: source.metadata,
                        ),
                      ),
                    ],

                    // -------------------------------------------------
                    // ERROR FROM BACKEND
                    // -------------------------------------------------
                    if (orchestrationResponse.error != null &&
                        orchestrationResponse.error!.trim().isNotEmpty) ...[
                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red.withValues(alpha: 0.08),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.30),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                orchestrationResponse.error!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],

          // ---------------------------------------------------------
          // SESSION
          // ---------------------------------------------------------
          const SizedBox(height: 24),

          Text(
            "Session ID : ${state.sessionId ?? "-"}",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),

          // ---------------------------------------------------------
          // LOADING
          // ---------------------------------------------------------
          if (state.loading) ...[
            const SizedBox(height: 24),

            const Center(child: CircularProgressIndicator()),
          ],

          // ---------------------------------------------------------
          // ERROR
          // ---------------------------------------------------------
          if (state.error != null) ...[
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withValues(alpha: 0.30)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      state.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ---------------------------------------------------------
          // EXISTING DB TABLE DISCOVERY UI
          //
          // KEEPING THIS UNCHANGED
          // ---------------------------------------------------------
          if (state.rankedTables.isNotEmpty) ...[
            const SizedBox(height: 32),

            const Text(
              "AI Suggested Tables",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            TableSuggestionList(
              tables: state.rankedTables,
              approvedTable: state.approvedTable,
              approveResponse: state.approveResponse,
              onApprove: (table) async {
                await ref
                    .read(workspaceControllerProvider.notifier)
                    .approveTable(
                      table: table.table,
                      matchedTerms: table.matchedTerms,
                    );

                final newState = ref.read(workspaceControllerProvider);

                if (newState.error == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${table.table} approved successfully"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(newState.error!),
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 32),

            // -------------------------------------------------------
            // EXISTING AI COPILOT PANEL
            // -------------------------------------------------------
            if (state.approveResponse != null)
              AiCopilotPanel(
                approvedTable: state.approvedTable!,
                approveResponse: state.approveResponse!,
              ),
          ],
        ],
      ),
    );
  }
}

// ===================================================================
// STRATEGY CHIP
// ===================================================================

class _StrategyChip extends StatelessWidget {
  final String strategy;

  const _StrategyChip({required this.strategy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue.withValues(alpha: 0.08),
      ),
      child: Text(
        strategy,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ===================================================================
// INFO ROW
// ===================================================================

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),

        Expanded(child: Text(value)),
      ],
    );
  }
}

// ===================================================================
// SOURCE CARD
// ===================================================================

class _SourceCard extends StatelessWidget {
  final String type;
  final String name;
  final Map<String, dynamic> metadata;

  const _SourceCard({
    required this.type,
    required this.name,
    required this.metadata,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedType = type.toUpperCase();

    if (normalizedType == "RAG") {
      return _buildRagSource(context);
    }

    if (normalizedType == "MCP") {
      return _buildMcpSource(context);
    }

    return _buildGenericSource(context);
  }

  // -----------------------------------------------------------------
  // RAG SOURCE
  // -----------------------------------------------------------------

  Widget _buildRagSource(BuildContext context) {
    final fileName = _stringValue("file_name");
    final pageNumber = _value("page_number");
    final chunkIndex = _value("chunk_index");
    final relevanceScore = _value("relevance_score");
    final evidence = _stringValue("evidence");

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -----------------------------------------------------------
          // TYPE + SPACE
          // -----------------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.purple.withValues(alpha: 0.10),
                ),
                child: const Text(
                  "RAG",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),

          // -----------------------------------------------------------
          // FILE
          // -----------------------------------------------------------
          if (fileName != null && fileName.isNotEmpty) ...[
            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.description_outlined, size: 18),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    fileName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],

          // -----------------------------------------------------------
          // PAGE / CHUNK / RELEVANCE
          // -----------------------------------------------------------
          if (pageNumber != null ||
              chunkIndex != null ||
              relevanceScore != null) ...[
            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (pageNumber != null)
                  _MetadataChip(label: "Page $pageNumber"),

                if (chunkIndex != null)
                  _MetadataChip(label: "Chunk $chunkIndex"),

                if (relevanceScore != null)
                  _MetadataChip(
                    label: "Relevance ${_formatRelevance(relevanceScore)}",
                  ),
              ],
            ),
          ],

          // -----------------------------------------------------------
          // EVIDENCE
          // -----------------------------------------------------------
          if (evidence != null && evidence.isNotEmpty) ...[
            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                evidence,
                style: const TextStyle(fontSize: 14, height: 1.45),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // -----------------------------------------------------------------
  // MCP SOURCE
  // -----------------------------------------------------------------

  Widget _buildMcpSource(BuildContext context) {
    final statusCode = _value("status_code");

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.green.withValues(alpha: 0.10),
            ),
            child: const Text(
              "MCP",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                if (statusCode != null) ...[
                  const SizedBox(height: 8),

                  Text(
                    "Status: $statusCode",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------
  // GENERIC SOURCE
  // -----------------------------------------------------------------

  Widget _buildGenericSource(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey.withValues(alpha: 0.10),
            ),
            child: Text(
              type,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------
  // METADATA HELPERS
  // -----------------------------------------------------------------

  String? _stringValue(String key) {
    final value = metadata[key];

    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    return text.isEmpty ? null : text;
  }

  dynamic _value(String key) {
    return metadata[key];
  }

  String _formatRelevance(dynamic value) {
    if (value is num) {
      return value.toStringAsFixed(3);
    }

    final parsed = double.tryParse(value?.toString() ?? "");

    if (parsed != null) {
      return parsed.toStringAsFixed(3);
    }

    return value?.toString() ?? "-";
  }
}

// ===================================================================
// METADATA CHIP
// ===================================================================

class _MetadataChip extends StatelessWidget {
  final String label;

  const _MetadataChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey.withValues(alpha: 0.08),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
      ),
    );
  }
}
