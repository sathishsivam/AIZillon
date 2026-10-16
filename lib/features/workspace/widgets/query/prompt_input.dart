import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/workspace_provider.dart';

class PromptInput extends ConsumerStatefulWidget {
  const PromptInput({super.key});

  @override
  ConsumerState<PromptInput> createState() => _PromptInputState();
}

class _PromptInputState extends ConsumerState<PromptInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _askAizillon() {
    final query = _controller.text.trim();

    if (query.isEmpty) return;

    ref.read(workspaceControllerProvider.notifier).askAizillon(query);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workspaceControllerProvider);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ask AIZillon AI",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Describe the information you need in natural language.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _controller,
              maxLines: 4,
              minLines: 3,
              decoration: InputDecoration(
                hintText:
                    "Example:\nWhat documents are required for account opening?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _askAizillon(),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: state.loading ? null : _askAizillon,
                icon:
                    state.loading
                        ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.auto_awesome),
                label: Text(state.loading ? "Thinking..." : "Ask AIZillon"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
