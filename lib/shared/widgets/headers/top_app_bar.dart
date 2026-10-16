import 'package:flutter/material.dart';
import 'package:aizillon/shared/layouts/responsive_layout.dart';

import 'app_search.dart';
import 'notification_button.dart';
import 'profile_menu.dart';
import 'theme_switch.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TopAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return AppBar(
      elevation: 0,
      centerTitle: false,

      // Explicit menu button on mobile
      leading:
          isMobile
              ? Builder(
                builder:
                    (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
              )
              : null,

      title: Text(title.isEmpty ? 'AIZillon' : title),

      actions: [
        if (!isMobile)
          const SizedBox(
            width: 280,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: AppSearch(),
            ),
          ),

        const NotificationButton(),

        if (!isMobile) const ThemeSwitch(),

        const SizedBox(width: 8),

        const ProfileMenu(),

        const SizedBox(width: 12),
      ],
    );
  }
}
