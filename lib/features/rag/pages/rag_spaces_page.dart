import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/rag_controller.dart';
import '../models/rag_space.dart';
import '../controllers/rag_state.dart';

class RagSpacesPage extends ConsumerStatefulWidget {
  const RagSpacesPage({super.key});

  @override
  ConsumerState<RagSpacesPage> createState() => _RagSpacesPageState();
}

class _RagSpacesPageState extends ConsumerState<RagSpacesPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(ragControllerProvider.notifier).loadSpaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ragControllerProvider);

    final totalSpaces = state.spaces.length;

    final totalDocuments = state.spaces.fold<int>(
      0,
      (total, space) => total + space.documentCount,
    );

    final totalChunks = state.spaces.fold<int>(
      0,
      (total, space) => total + space.chunkCount,
    );

    final activeSpaces =
        state.spaces
            .where((space) => space.status.toUpperCase() == 'ACTIVE')
            .length;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------------------------------------
            // Header
            // --------------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RAG Spaces',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Create and manage document knowledge spaces for AI agents.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {
                    context.go('/admin/rag/create');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create RAG Space'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------------
            // Summary
            // --------------------------------------------------------
            Row(
              children: [
                _SummaryCard(
                  title: 'RAG Spaces',
                  value: '$totalSpaces',
                  icon: Icons.library_books_outlined,
                ),
                const SizedBox(width: 16),
                _SummaryCard(
                  title: 'Documents',
                  value: '$totalDocuments',
                  icon: Icons.description_outlined,
                ),
                const SizedBox(width: 16),
                _SummaryCard(
                  title: 'Indexed Chunks',
                  value: '$totalChunks',
                  icon: Icons.data_object_outlined,
                ),
                const SizedBox(width: 16),
                _SummaryCard(
                  title: 'Active',
                  value: '$activeSpaces',
                  icon: Icons.check_circle_outline,
                ),
              ],
            ),

            const SizedBox(height: 32),

            Text(
              'Knowledge Spaces',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            // --------------------------------------------------------
            // Content
            // --------------------------------------------------------
            Expanded(child: _buildContent(context, state)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, RagState state) {
    if (state.isLoadingSpaces) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.spaces.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(state.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                ref.read(ragControllerProvider.notifier).loadSpaces();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.spaces.isEmpty) {
      return _EmptySpacesView(
        onCreate: () {
          context.go('/admin/rag/create');
        },
      );
    }

    return ListView.builder(
      itemCount: state.spaces.length,
      itemBuilder: (context, index) {
        final space = state.spaces[index];

        return _RagSpaceCard(
          space: space,
          onTap: () {
            context.go('/admin/rag/space/${space.id}');
          },
        );
      },
    );
  }
}

// =============================================================================
// Summary Card
// =============================================================================

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(title),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// RAG Space Card
// =============================================================================

class _RagSpaceCard extends StatelessWidget {
  final RagSpace space;
  final VoidCallback onTap;

  const _RagSpaceCard({required this.space, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = space.status.toUpperCase() == 'ACTIVE';

    final isIndexed =
        space.status.toUpperCase() == 'INDEXED' ||
        space.status.toUpperCase() == 'COMPLETED';

    String displayStatus;

    if (isActive) {
      displayStatus = 'Active';
    } else if (isIndexed) {
      displayStatus = 'Indexed';
    } else {
      displayStatus = space.status;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: const CircleAvatar(child: Icon(Icons.menu_book_outlined)),
        title: Text(
          space.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(space.description),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${space.documentCount} docs'),
            const SizedBox(width: 20),
            Text('${space.chunkCount} chunks'),
            const SizedBox(width: 20),
            Chip(label: Text(displayStatus)),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

// =============================================================================
// Empty State
// =============================================================================

class _EmptySpacesView extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptySpacesView({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No RAG Spaces',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a RAG Space to start building your knowledge base.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('Create RAG Space'),
          ),
        ],
      ),
    );
  }
}
