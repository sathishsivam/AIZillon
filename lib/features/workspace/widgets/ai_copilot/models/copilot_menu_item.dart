import 'package:flutter/material.dart';

import 'copilot_view.dart';

class CopilotMenuItem {
  final String title;
  final IconData icon;
  final CopilotView view;

  const CopilotMenuItem({
    required this.title,
    required this.icon,
    required this.view,
  });
}
