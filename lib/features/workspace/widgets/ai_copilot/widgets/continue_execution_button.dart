import 'package:flutter/material.dart';

class ContinueExecutionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ContinueExecutionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FilledButton.icon(
        icon: const Icon(Icons.play_arrow),
        label: const Text("Continue to SQL Generation"),
        onPressed: onPressed,
      ),
    );
  }
}
