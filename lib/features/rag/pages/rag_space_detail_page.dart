import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/rag_controller.dart';
import '../controllers/rag_state.dart';
import '../models/rag_document.dart';
import '../models/rag_retrieval.dart';
import '../models/rag_space.dart';

class RagSpaceDetailPage extends ConsumerStatefulWidget {
  final String spaceId;

  const RagSpaceDetailPage({super.key, required this.spaceId});

  @override
  ConsumerState<RagSpaceDetailPage> createState() => _RagSpaceDetailPageState();
}

class _RagSpaceDetailPageState extends ConsumerState<RagSpaceDetailPage> {
  final TextEditingController _queryController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(ragControllerProvider.notifier).selectSpace(widget.spaceId);
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ragControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(state.selectedSpace?.name ?? 'RAG Space'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: state.isLoadingDocuments ? null : _refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(context, state),
    );
  }

  // ===========================================================================
  // BODY
  // ===========================================================================

  Widget _buildBody(BuildContext context, RagState state) {
    if (state.isLoadingDocuments && state.selectedSpace == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.selectedSpace == null) {
      return _buildErrorState(context, state.errorMessage!);
    }

    final space = state.selectedSpace;

    if (space == null) {
      return const Center(child: Text('RAG Space not found.'));
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSpaceHeader(context, space, state),

          const SizedBox(height: 24),

          _buildStatistics(context, space, state),

          const SizedBox(height: 24),

          _buildRetrievalSection(context, state),

          const SizedBox(height: 24),

          _buildDocumentsSection(context, state),

          if (state.errorMessage != null) ...[
            const SizedBox(height: 16),
            _buildErrorBanner(context, state.errorMessage!),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // SPACE HEADER
  // ===========================================================================

  Widget _buildSpaceHeader(
    BuildContext context,
    RagSpace space,
    RagState state,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.library_books_outlined,
                size: 30,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    space.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  if (space.description != null &&
                      space.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(space.description!, style: theme.textTheme.bodyMedium),
                  ],

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoChip(
                        icon: Icons.memory_outlined,
                        label: space.embeddingModel ?? 'Embedding model',
                      ),
                      _InfoChip(
                        icon: Icons.storage_outlined,
                        label: space.vectorStore ?? 'Vector store',
                      ),
                      _StatusChip(status: space.status),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            FilledButton.icon(
              onPressed: state.isUploadingDocument ? null : _uploadDocument,
              icon:
                  state.isUploadingDocument
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.upload_file),
              label: Text(
                state.isUploadingDocument ? 'Uploading...' : 'Upload Document',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // STATISTICS
  // ===========================================================================

  Widget _buildStatistics(
    BuildContext context,
    RagSpace space,
    RagState state,
  ) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.description_outlined,
            title: 'Documents',
            value: '${state.documents.length}',
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _StatCard(
            icon: Icons.view_module_outlined,
            title: 'Chunks',
            value: '${space.chunkCount ?? 0}',
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _StatCard(
            icon: Icons.layers_outlined,
            title: 'Chunk Size',
            value: '${space.chunkSize ?? 1000}',
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _StatCard(
            icon: Icons.compare_arrows_outlined,
            title: 'Overlap',
            value: '${space.chunkOverlap ?? 150}',
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // RETRIEVAL
  // ===========================================================================

  Widget _buildRetrievalSection(BuildContext context, RagState state) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.search, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Text(
                  'Test Retrieval',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Ask a question to verify that '
              'the documents in this RAG Space '
              'are being retrieved correctly.',
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _queryController,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _retrieve(),
                    decoration: InputDecoration(
                      hintText: 'Example: What is the PPS process?',
                      prefixIcon: const Icon(Icons.question_answer_outlined),
                      suffixIcon:
                          _queryController.text.isNotEmpty
                              ? IconButton(
                                tooltip: 'Clear',
                                onPressed: () {
                                  _queryController.clear();

                                  ref
                                      .read(ragControllerProvider.notifier)
                                      .clearRetrieval();

                                  setState(() {});
                                },
                                icon: const Icon(Icons.clear),
                              )
                              : null,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                ),

                const SizedBox(width: 12),

                FilledButton.icon(
                  onPressed: state.isRetrieving ? null : _retrieve,
                  icon:
                      state.isRetrieving
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.search),
                  label: const Text('Retrieve'),
                ),
              ],
            ),

            if (state.retrievalResponse != null) ...[
              const SizedBox(height: 20),

              _buildRetrievalResults(context, state.retrievalResponse!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRetrievalResults(
    BuildContext context,
    RagRetrievalResponse response,
  ) {
    final theme = Theme.of(context);
    final documents = response.documents;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                response.status.toUpperCase() == 'SUCCESS'
                    ? Icons.check_circle_outline
                    : Icons.info_outline,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  'Status: ${response.status}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Text(
                '${documents.length} chunks',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        if (response.context.trim().isNotEmpty) ...[
          Text(
            'Retrieved Context',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SelectableText(
              response.context,
              style: theme.textTheme.bodyMedium,
            ),
          ),

          const SizedBox(height: 20),
        ],

        Row(
          children: [
            Text(
              'Retrieved Documents',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Chip(
              label: Text('${documents.length}'),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),

        const SizedBox(height: 12),

        if (documents.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: const Column(
              children: [
                Icon(Icons.search_off, size: 36),
                SizedBox(height: 8),
                Text('No matching chunks found.'),
              ],
            ),
          )
        else
          ...List.generate(documents.length, (index) {
            return _RetrievedDocumentTile(
              index: index + 1,
              document: documents[index],
            );
          }),

        if (response.sources.isNotEmpty) ...[
          const SizedBox(height: 20),

          Text(
            'Sources',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                response.sources
                    .map((source) => _SourceChip(source: source))
                    .toList(),
          ),
        ],
      ],
    );
  }

  // ===========================================================================
  // DOCUMENTS
  // ===========================================================================

  Widget _buildDocumentsSection(BuildContext context, RagState state) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.folder_open_outlined,
                  color: theme.colorScheme.primary,
                ),

                const SizedBox(width: 10),

                Text(
                  'Documents',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(width: 8),

                if (state.isLoadingDocuments)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),

                const Spacer(),

                OutlinedButton.icon(
                  onPressed: state.isUploadingDocument ? null : _uploadDocument,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Document'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (state.documents.isEmpty)
              _buildEmptyDocuments(context)
            else
              Column(
                children: [
                  for (final document in state.documents)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _DocumentTile(
                        document: document,
                        isDeleting: state.isDeletingDocument,
                        onView: () => _viewDocument(document),
                        onDelete: () => _deleteDocument(document),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyDocuments(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(
            Icons.description_outlined,
            size: 48,
            color: theme.colorScheme.outline,
          ),

          const SizedBox(height: 12),

          Text(
            'No documents yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Upload PDF, DOCX, TXT or '
            'Markdown files to build this '
            'knowledge base.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),

          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: _uploadDocument,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload First Document'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // UPLOAD
  // ===========================================================================

  Future<void> _uploadDocument() async {
    try {
      // -----------------------------------------------------------------------
      // IMPORTANT FOR FLUTTER WEB
      //
      // withData: true makes file.bytes available.
      //
      // Do NOT use:
      //   file.path
      //   MultipartFile.fromFile(...)
      //
      // Those approaches depend on dart:io and are not suitable for Flutter Web.
      // -----------------------------------------------------------------------

      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'txt', 'md'],
        allowMultiple: false,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.single;

      final fileBytes = file.bytes;

      if (fileBytes == null || fileBytes.isEmpty) {
        _showError('Unable to read the selected file.');
        return;
      }

      debugPrint('RAG UI: Selected file: ${file.name}');

      debugPrint('RAG UI: File size: ${fileBytes.length} bytes');

      // -----------------------------------------------------------------------
      // Upload using bytes.
      // -----------------------------------------------------------------------

      final success = await ref
          .read(ragControllerProvider.notifier)
          .uploadDocument(fileBytes: fileBytes, fileName: file.name);

      if (!mounted) {
        return;
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${file.name} uploaded successfully.')),
        );
      } else {
        final error = ref.read(ragControllerProvider).errorMessage;

        if (error != null && error.isNotEmpty) {
          _showError(error);
        }
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ===========================================================================
  // VIEW DOCUMENT
  // ===========================================================================

  Future<void> _viewDocument(RagDocument document) async {
    final result = await ref
        .read(ragControllerProvider.notifier)
        .getDocument(document.id);

    if (!mounted) {
      return;
    }

    if (result == null) {
      final error = ref.read(ragControllerProvider).errorMessage;

      if (error != null) {
        _showError(error);
      }

      return;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return _DocumentDetailsDialog(document: result);
      },
    );
  }

  // ===========================================================================
  // DELETE DOCUMENT
  // ===========================================================================

  Future<void> _deleteDocument(RagDocument document) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Document'),
          content: Text(
            'Are you sure you want to '
            'delete "${document.fileName}"?\n\n'
            'The FAISS index will be '
            'rebuilt after deletion.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final success = await ref
        .read(ragControllerProvider.notifier)
        .deleteDocument(document.id);

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${document.fileName} deleted successfully.')),
      );
    } else {
      final error = ref.read(ragControllerProvider).errorMessage;

      if (error != null) {
        _showError(error);
      }
    }
  }

  // ===========================================================================
  // RETRIEVE
  // ===========================================================================

  Future<void> _retrieve() async {
    final query = _queryController.text.trim();

    if (query.isEmpty) {
      _showError('Please enter a query.');
      return;
    }

    await ref
        .read(ragControllerProvider.notifier)
        .retrieve(query: query, topK: 5);
  }

  // ===========================================================================
  // REFRESH
  // ===========================================================================

  Future<void> _refresh() async {
    await ref.read(ragControllerProvider.notifier).selectSpace(widget.spaceId);
  }

  // ===========================================================================
  // ERROR
  // ===========================================================================

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),

            const SizedBox(height: 16),

            Text(
              'Unable to load RAG Space',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 8),

            Text(message, textAlign: TextAlign.center),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, String message) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              message,
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

// =============================================================================
// DOCUMENT TILE
// =============================================================================

class _DocumentTile extends StatelessWidget {
  final RagDocument document;
  final bool isDeleting;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const _DocumentTile({
    required this.document,
    required this.isDeleting,
    required this.onView,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _fileIcon(document.fileName),
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
        title: Text(
          document.fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _StatusChip(status: document.status),
              _InfoChip(
                icon: Icons.menu_book_outlined,
                label: '${document.pageCount} pages',
              ),
              _InfoChip(
                icon: Icons.view_module_outlined,
                label: '${document.chunkCount} chunks',
              ),
              _InfoChip(
                icon: Icons.insert_drive_file_outlined,
                label: _formatBytes(document.fileSize),
              ),
            ],
          ),
        ),
        trailing:
            isDeleting
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : PopupMenuButton<String>(
                  tooltip: 'Document actions',
                  onSelected: (value) {
                    switch (value) {
                      case 'view':
                        onView();
                        break;

                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                  itemBuilder:
                      (context) => const [
                        PopupMenuItem<String>(
                          value: 'view',
                          child: ListTile(
                            leading: Icon(Icons.visibility_outlined),
                            title: Text('View'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete_outline),
                            title: Text('Delete'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                ),
      ),
    );
  }

  IconData _fileIcon(String fileName) {
    final lower = fileName.toLowerCase();

    if (lower.endsWith('.pdf')) {
      return Icons.picture_as_pdf_outlined;
    }

    if (lower.endsWith('.docx')) {
      return Icons.article_outlined;
    }

    if (lower.endsWith('.md')) {
      return Icons.code_outlined;
    }

    if (lower.endsWith('.txt')) {
      return Icons.notes_outlined;
    }

    return Icons.insert_drive_file_outlined;
  }
}

// =============================================================================
// RETRIEVED DOCUMENT
// =============================================================================

class _RetrievedDocumentTile extends StatelessWidget {
  final int index;
  final RagRetrievedDocument document;

  const _RetrievedDocumentTile({required this.index, required this.document});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: ExpansionTile(
        leading: CircleAvatar(radius: 18, child: Text('$index')),
        title: Text(
          document.fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _subtitle(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SelectableText(
              document.content,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _subtitle() {
    final parts = <String>[];

    if (document.pageNumber != null) {
      parts.add('Page ${document.pageNumber}');
    }

    if (document.chunkIndex != null) {
      parts.add('Chunk ${document.chunkIndex}');
    }

    if (document.documentId.isNotEmpty) {
      parts.add('Document ${document.documentId}');
    }

    return parts.join(' • ');
  }
}

// =============================================================================
// SOURCE CHIP
// =============================================================================

class _SourceChip extends StatelessWidget {
  final RagRetrievalSource source;

  const _SourceChip({required this.source});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[source.fileName];

    if (source.pageNumber != null) {
      parts.add('Page ${source.pageNumber}');
    }

    if (source.chunkIndex != null) {
      parts.add('Chunk ${source.chunkIndex}');
    }

    return Chip(
      avatar: const Icon(Icons.description_outlined, size: 18),
      label: Text(parts.join(' • ')),
    );
  }
}

// =============================================================================
// DOCUMENT DETAILS
// =============================================================================

class _DocumentDetailsDialog extends StatelessWidget {
  final RagDocument document;

  const _DocumentDetailsDialog({required this.document});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.description_outlined),
          const SizedBox(width: 10),
          Expanded(
            child: Text(document.fileName, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
      content: SizedBox(
        width: 550,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(label: 'Document ID', value: document.id),
              _DetailRow(label: 'Space ID', value: document.spaceId),
              _DetailRow(label: 'File name', value: document.fileName),
              _DetailRow(label: 'File type', value: document.fileType),
              _DetailRow(label: 'Status', value: document.status),
              _DetailRow(label: 'Pages', value: '${document.pageCount}'),
              _DetailRow(label: 'Chunks', value: '${document.chunkCount}'),
              _DetailRow(
                label: 'File size',
                value: _formatBytes(document.fileSize),
              ),
              if (document.createdAt != null)
                _DetailRow(
                  label: 'Created',
                  value: document.createdAt!.toLocal().toString(),
                ),
              if (document.updatedAt != null)
                _DetailRow(
                  label: 'Updated',
                  value: document.updatedAt!.toLocal().toString(),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

// =============================================================================
// STAT CARD
// =============================================================================

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// INFO CHIP
// =============================================================================

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 5),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

// =============================================================================
// STATUS CHIP
// =============================================================================

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;

    switch (status.toUpperCase()) {
      case 'COMPLETED':
      case 'ACTIVE':
        icon = Icons.check_circle_outline;
        break;

      case 'PROCESSING':
        icon = Icons.sync;
        break;

      case 'FAILED':
        icon = Icons.error_outline;
        break;

      default:
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 5),
          Text(
            status,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// DETAIL ROW
// =============================================================================

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

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
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }
}

// =============================================================================
// HELPERS
// =============================================================================

String _formatBytes(int bytes) {
  if (bytes < 1024) {
    return '$bytes B';
  }

  if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  }

  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
}
