import 'package:flutter/material.dart';

class TableIcon extends StatelessWidget {
  const TableIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.table_chart_rounded,
        color: Colors.orange,
        size: 28,
      ),
    );
  }
}
