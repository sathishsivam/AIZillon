import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:aizillon/shared/navigation/navigation_data.dart';
import 'package:aizillon/shared/navigation/navigation_item.dart';

class SideNavigation extends StatelessWidget {
  const SideNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;

    return Container(
      width: 280,
      color: Colors.white,
      child: Column(
        children: [
          _buildLogo(),

          const Divider(height: 1),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              itemCount: NavigationData.items.length,
              itemBuilder: (context, index) {
                return _buildItem(
                  context,
                  NavigationData.items[index],
                  currentRoute,
                );
              },
            ),
          ),

          const Divider(height: 1),

          _buildProfile(),
        ],
      ),
    );
  }

  // Widget _buildLogo() {
  //   return Container(
  //     height: 80,
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     alignment: Alignment.centerLeft,
  //     child: const Text(
  //       "Aizillon",
  //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //     ),
  //   );
  // }
  Widget _buildLogo() {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Image.asset(
            'assets/images/i-exceed.png',
            width: 48,
            height: 48,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.blue,
                  size: 28,
                ),
              );
            },
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AIZillon",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 2),

                Text(
                  "Enterprise AI Platform",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    NavigationItem item,
    String currentRoute,
  ) {
    final selected = currentRoute == item.route;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: selected ? Colors.blue.shade50 : null,
        leading: Icon(
          item.icon,
          color: selected ? Colors.blue : Colors.grey.shade700,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: selected ? Colors.blue : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          context.go(item.route);
          Navigator.of(context).maybePop(); // closes the drawer on mobile
        },
      ),
    );
  }

  Widget _buildProfile() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Row(
        children: [
          CircleAvatar(child: Icon(Icons.person)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Sathish Sivam",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
