import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'copilot_provider.dart';

import 'models/copilot_menu_item.dart';
import 'models/copilot_view.dart';

class CopilotMenu extends ConsumerWidget {
  const CopilotMenu({super.key});

  static const items = [
    CopilotMenuItem(
      title: "Overview",
      icon: Icons.dashboard_outlined,
      view: CopilotView.overview,
    ),
    CopilotMenuItem(
      title: "Schema",
      icon: Icons.table_chart_outlined,
      view: CopilotView.schema,
    ),
    CopilotMenuItem(
      title: "Business Mapping",
      icon: Icons.account_tree_outlined,
      view: CopilotView.businessMapping,
    ),
    CopilotMenuItem(
      title: "Resolved Columns",
      icon: Icons.checklist_outlined,
      view: CopilotView.resolvedColumns,
    ),
    CopilotMenuItem(
      title: "Filters",
      icon: Icons.filter_alt_outlined,
      view: CopilotView.filters,
    ),
    CopilotMenuItem(
      title: "Relationships",
      icon: Icons.hub_outlined,
      view: CopilotView.relationships,
    ),
    CopilotMenuItem(
      title: "Sample Data",
      icon: Icons.dataset_outlined,
      view: CopilotView.sampleData,
    ),
    CopilotMenuItem(
      title: "Execute",
      icon: Icons.play_circle_outline,
      view: CopilotView.execute,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedView = ref.watch(copilotProvider);

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        final selected = selectedView == item.view;

        return Card(
          elevation: selected ? 2 : 0,
          color: selected ? Colors.blue.shade50 : Colors.transparent,
          child: ListTile(
            leading: Icon(
              item.icon,
              color: selected ? Colors.blue : Colors.grey.shade700,
            ),
            title: Text(
              item.title,
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? Colors.blue : Colors.black87,
              ),
            ),
            selected: selected,
            onTap: () {
              ref.read(copilotProvider.notifier).changeView(item.view);
            },
          ),
        );
      },
    );
  }
}
