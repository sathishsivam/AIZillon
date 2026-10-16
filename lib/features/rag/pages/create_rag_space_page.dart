import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/rag_controller.dart';

class CreateRagSpacePage extends ConsumerStatefulWidget {
  const CreateRagSpacePage({super.key});

  @override
  ConsumerState<CreateRagSpacePage> createState() => _CreateRagSpacePageState();
}

class _CreateRagSpacePageState extends ConsumerState<CreateRagSpacePage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _embeddingModel = 'nomic-embed-text';
  String _vectorStore = 'FAISS';

  double _chunkSize = 1000;
  double _chunkOverlap = 150;

  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Create RAG Space
  // ---------------------------------------------------------------------------

  Future<void> _createSpace() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a RAG Space name.')),
      );
      return;
    }

    if (_isCreating) {
      return;
    }

    setState(() {
      _isCreating = true;
    });

    final success = await ref
        .read(ragControllerProvider.notifier)
        .createSpace(
          name: name,
          description: description,
          embeddingModel: _embeddingModel,
          vectorStore: _vectorStore,
          chunkSize: _chunkSize.round(),
          chunkOverlap: _chunkOverlap.round(),
        );

    if (!mounted) {
      return;
    }

    setState(() {
      _isCreating = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('RAG Space created successfully.')),
      );

      // Navigate back to the RAG Spaces list.
      // The controller already contains the newly created space.
      context.go('/admin/rag');
    } else {
      final errorMessage = ref.read(ragControllerProvider).errorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage ?? 'Failed to create RAG Space.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create RAG Space')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --------------------------------------------------------
                    // Title
                    // --------------------------------------------------------
                    Text(
                      'Knowledge Space Configuration',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --------------------------------------------------------
                    // Name
                    // --------------------------------------------------------
                    TextField(
                      controller: _nameController,
                      enabled: !_isCreating,
                      decoration: const InputDecoration(
                        labelText: 'RAG Space Name',
                        hintText: 'Example: Banking Policies',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // --------------------------------------------------------
                    // Description
                    // --------------------------------------------------------
                    TextField(
                      controller: _descriptionController,
                      enabled: !_isCreating,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText:
                            'Describe the knowledge contained in this space.',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --------------------------------------------------------
                    // Embedding Model
                    // --------------------------------------------------------
                    DropdownButtonFormField<String>(
                      value: _embeddingModel,
                      decoration: const InputDecoration(
                        labelText: 'Embedding Model',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'nomic-embed-text',
                          child: Text('nomic-embed-text'),
                        ),
                        DropdownMenuItem(
                          value: 'mxbai-embed-large',
                          child: Text('mxbai-embed-large'),
                        ),
                      ],
                      onChanged:
                          _isCreating
                              ? null
                              : (value) {
                                if (value != null) {
                                  setState(() {
                                    _embeddingModel = value;
                                  });
                                }
                              },
                    ),

                    const SizedBox(height: 16),

                    // --------------------------------------------------------
                    // Vector Store
                    // --------------------------------------------------------
                    DropdownButtonFormField<String>(
                      value: _vectorStore,
                      decoration: const InputDecoration(
                        labelText: 'Vector Store',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'FAISS', child: Text('FAISS')),
                        DropdownMenuItem(
                          value: 'Chroma',
                          child: Text('Chroma'),
                        ),
                        DropdownMenuItem(
                          value: 'Qdrant',
                          child: Text('Qdrant'),
                        ),
                      ],
                      onChanged:
                          _isCreating
                              ? null
                              : (value) {
                                if (value != null) {
                                  setState(() {
                                    _vectorStore = value;
                                  });
                                }
                              },
                    ),

                    const SizedBox(height: 24),

                    // --------------------------------------------------------
                    // Chunking
                    // --------------------------------------------------------
                    Text(
                      'Chunking',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text('Chunk Size: ${_chunkSize.round()}'),

                    Slider(
                      value: _chunkSize,
                      min: 200,
                      max: 3000,
                      divisions: 28,
                      label: _chunkSize.round().toString(),
                      onChanged:
                          _isCreating
                              ? null
                              : (value) {
                                setState(() {
                                  _chunkSize = value;
                                });
                              },
                    ),

                    const SizedBox(height: 8),

                    Text('Chunk Overlap: ${_chunkOverlap.round()}'),

                    Slider(
                      value: _chunkOverlap,
                      min: 0,
                      max: 500,
                      divisions: 20,
                      label: _chunkOverlap.round().toString(),
                      onChanged:
                          _isCreating
                              ? null
                              : (value) {
                                setState(() {
                                  _chunkOverlap = value;
                                });
                              },
                    ),

                    const SizedBox(height: 32),

                    // --------------------------------------------------------
                    // Actions
                    // --------------------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed:
                              _isCreating
                                  ? null
                                  : () {
                                    context.go('/admin/rag');
                                  },
                          child: const Text('Cancel'),
                        ),

                        const SizedBox(width: 12),

                        FilledButton.icon(
                          onPressed: _isCreating ? null : _createSpace,
                          icon:
                              _isCreating
                                  ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Icon(Icons.add),
                          label: Text(
                            _isCreating ? 'Creating...' : 'Create RAG Space',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
