import 'package:flutter/material.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.dark_mode_outlined),
      onPressed: () {
        // TODO: Connect to Riverpod theme provider
      },
    );
  }
}
