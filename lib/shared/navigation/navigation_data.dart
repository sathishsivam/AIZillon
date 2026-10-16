import 'package:flutter/material.dart';

import 'navigation_item.dart';

//
// class NavigationData {
//   static const items = [
//     NavigationItem(
//       title: 'Dashboard',
//       route: '/',
//       icon: Icons.dashboard_outlined,
//     ),
//
//     NavigationItem(
//       title: 'Workspace',
//       route: '/workspace',
//       icon: Icons.workspaces_outline,
//     ),
//
//     NavigationItem(
//       title: 'Data Sources',
//       route: '/datasource',
//       icon: Icons.storage_outlined,
//     ),
//
//     NavigationItem(
//       title: 'Metadata',
//       route: '/metadata',
//       icon: Icons.schema_outlined,
//     ),
//
//     NavigationItem(
//       title: 'Prompt Studio',
//       route: '/promptstudio',
//       icon: Icons.auto_fix_high_outlined,
//     ),
//
//     NavigationItem(
//       title: 'Workflow',
//       route: '/workflow',
//       icon: Icons.account_tree_outlined,
//     ),
//
//     NavigationItem(
//       title: 'AI Agents',
//       route: '/agents',
//       icon: Icons.smart_toy_outlined,
//     ),
//
//     // NEW
//     NavigationItem(
//       title: 'MCP Builder',
//       route: '/mcp-builder',
//       icon: Icons.hub_outlined,
//     ),
//
//     NavigationItem(
//       title: 'Charts',
//       route: '/charts',
//       icon: Icons.bar_chart_outlined,
//     ),
//
//     NavigationItem(
//       title: 'Insights',
//       route: '/insight',
//       icon: Icons.lightbulb_outline,
//     ),
//
//     NavigationItem(
//       title: 'Reports',
//       route: '/reports',
//       icon: Icons.description_outlined,
//     ),
//
//     NavigationItem(
//       title: 'Monitoring',
//       route: '/monitoring',
//       icon: Icons.monitor_heart_outlined,
//     ),
//
//     NavigationItem(
//       title: 'Administration',
//       route: '/admin',
//       icon: Icons.admin_panel_settings_outlined,
//     ),
//   ];
// }

// import 'package:flutter/material.dart';
//
// import 'navigation_item.dart';

class NavigationData {
  static const items = [
    NavigationItem(
      title: 'Dashboard',
      route: '/',
      icon: Icons.dashboard_outlined,
    ),

    NavigationItem(
      title: 'Workspace',
      route: '/workspace',
      icon: Icons.workspaces_outline,
    ),

    NavigationItem(
      title: 'Data Sources',
      route: '/datasource',
      icon: Icons.storage_outlined,
    ),

    NavigationItem(
      title: 'Metadata',
      route: '/metadata',
      icon: Icons.schema_outlined,
    ),

    NavigationItem(
      title: 'Prompt Studio',
      route: '/promptstudio',
      icon: Icons.auto_fix_high_outlined,
    ),

    NavigationItem(
      title: 'Workflow',
      route: '/workflow',
      icon: Icons.account_tree_outlined,
    ),

    NavigationItem(
      title: 'AI Agents',
      route: '/agents',
      icon: Icons.smart_toy_outlined,
    ),

    // ------------------------------------------------------------
    // MCP Builder
    // ------------------------------------------------------------
    NavigationItem(
      title: 'MCP Builder',
      route: '/mcp-builder',
      icon: Icons.hub_outlined,
    ),

    NavigationItem(
      title: 'Charts',
      route: '/charts',
      icon: Icons.bar_chart_outlined,
    ),

    NavigationItem(
      title: 'Insights',
      route: '/insight',
      icon: Icons.lightbulb_outline,
    ),

    NavigationItem(
      title: 'Reports',
      route: '/reports',
      icon: Icons.description_outlined,
    ),

    NavigationItem(
      title: 'Monitoring',
      route: '/monitoring',
      icon: Icons.monitor_heart_outlined,
    ),

    // ------------------------------------------------------------
    // Administration
    // ------------------------------------------------------------
    NavigationItem(
      title: 'Administration',
      route: '/admin',
      icon: Icons.admin_panel_settings_outlined,
    ),

    // ------------------------------------------------------------
    // RAG Administration
    // ------------------------------------------------------------
    NavigationItem(
      title: 'RAG Management',
      route: '/admin/rag',
      icon: Icons.menu_book_outlined,
    ),
  ];
}
