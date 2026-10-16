import 'package:flutter/material.dart';

import 'package:aizillon/shared/layouts/responsive_layout.dart';
import 'package:aizillon/shared/widgets/side_navigation.dart';
import 'package:aizillon/shared/widgets/headers/top_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:aizillon/shared/navigation/navigation_data.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    String pageTitle = "Aizillon";

    for (final item in NavigationData.items) {
      if (item.route == location) {
        pageTitle = item.title;
        break;
      }
    }
    final desktop = ResponsiveLayout.isDesktop(context);

    if (desktop) {
      return Scaffold(
        body: Row(
          children: [
            const SideNavigation(),

            Expanded(
              child: Column(
                children: [
                  TopAppBar(title: pageTitle),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: TopAppBar(title: "Dashboard"),

      drawer: const Drawer(child: SideNavigation()),

      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}
