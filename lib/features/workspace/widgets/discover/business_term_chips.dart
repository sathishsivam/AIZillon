import 'package:flutter/material.dart';

class BusinessTermChips extends StatelessWidget {
  final List<String> terms;

  const BusinessTermChips({super.key, required this.terms});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          terms.map((term) {
            return Chip(
              label: Text(term),
              backgroundColor: Colors.orange.shade50,
              side: BorderSide.none,
              avatar: const Icon(
                Icons.sell_outlined,
                size: 16,
                color: Colors.orange,
              ),
            );
          }).toList(),
    );
  }
}
