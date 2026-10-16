import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/pages/dashboard_page.dart';
import '../../features/workspace/pages/workspace_page.dart';

import '../../features/mcp_builder/pages/mcp_servers_page.dart';
import '../../features/mcp_builder/pages/create_mcp_server_page.dart';
import '../../features/mcp_builder/pages/mcp_tool_execution_page.dart';
import '../../features/mcp_builder/pages/api_discovery_page.dart';
import '../../features/mcp_builder/models/mcp_tool.dart';

import '../../features/rag/pages/rag_spaces_page.dart';
import '../../features/rag/pages/create_rag_space_page.dart';
import '../../features/rag/pages/rag_space_detail_page.dart';

import '../../shared/layouts/app_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    // ============================================================
    // APPLICATION SHELL
    // ============================================================
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },

      routes: [
        // ========================================================
        // Dashboard
        // ========================================================
        GoRoute(
          path: '/',
          name: 'dashboard',
          builder: (context, state) {
            return const DashboardPage();
          },
        ),

        // ========================================================
        // Workspace
        // ========================================================
        GoRoute(
          path: '/workspace',
          name: 'workspace',
          builder: (context, state) {
            return const WorkspacePage();
          },
        ),

        // ========================================================
        // MCP Builder
        // ========================================================
        GoRoute(
          path: '/mcp-builder',
          name: 'mcp-builder',
          builder: (context, state) {
            return const McpServersPage();
          },

          routes: [
            // ----------------------------------------------------
            // Create MCP Server
            //
            // /mcp-builder/create
            // ----------------------------------------------------
            GoRoute(
              path: 'create',
              name: 'create-mcp-server',
              builder: (context, state) {
                return const CreateMcpServerPage();
              },
            ),

            // ----------------------------------------------------
            // MCP Tool Execution
            //
            // /mcp-builder/execute
            // ----------------------------------------------------
            GoRoute(
              path: 'execute',
              name: 'execute-mcp-tool',
              builder: (context, state) {
                final extra = state.extra;

                if (extra is! McpTool) {
                  return const Scaffold(
                    body: Center(
                      child: Text('MCP tool information was not provided.'),
                    ),
                  );
                }

                return McpToolExecutionPage(tool: extra);
              },
            ),

            // ----------------------------------------------------
            // API Discovery
            //
            // /mcp-builder/discover
            // ----------------------------------------------------
            GoRoute(
              path: 'discover',
              name: 'api-discovery',
              builder: (context, state) {
                final extra = state.extra;

                if (extra is! Map<String, dynamic>) {
                  return const Scaffold(
                    body: Center(
                      child: Text(
                        'API discovery information was not provided.',
                      ),
                    ),
                  );
                }

                final baseUrl = extra['baseUrl'];

                if (baseUrl is! String || baseUrl.isEmpty) {
                  return const Scaffold(
                    body: Center(child: Text('Base URL was not provided.')),
                  );
                }

                return ApiDiscoveryPage(baseUrl: baseUrl);
              },
            ),
          ],
        ),

        // ========================================================
        // RAG Administration
        // ========================================================
        GoRoute(
          path: '/admin/rag',
          name: 'rag-spaces',
          builder: (context, state) {
            return const RagSpacesPage();
          },

          routes: [
            // ----------------------------------------------------
            // Create RAG Space
            //
            // /admin/rag/create
            // ----------------------------------------------------
            GoRoute(
              path: 'create',
              name: 'create-rag-space',
              builder: (context, state) {
                return const CreateRagSpacePage();
              },
            ),

            // ----------------------------------------------------
            // RAG Space Detail
            //
            // /admin/rag/space/:spaceId
            // ----------------------------------------------------
            GoRoute(
              path: 'space/:spaceId',
              name: 'rag-space-detail',
              builder: (context, state) {
                final spaceId = state.pathParameters['spaceId'];

                if (spaceId == null || spaceId.isEmpty) {
                  return const Scaffold(
                    body: Center(child: Text('RAG Space ID was not provided.')),
                  );
                }

                return RagSpaceDetailPage(spaceId: spaceId);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
