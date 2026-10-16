import 'package:flutter/material.dart';

import 'app_card.dart';

class StatusCard extends StatelessWidget {
  final String title;
  final String status;
  final Color color;

  const StatusCard({
    super.key,
    required this.title,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(radius: 6, backgroundColor: color),

          const SizedBox(width: 12),

          Expanded(child: Text(title)),

          Text(
            status,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
