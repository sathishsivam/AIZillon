import 'package:flutter/material.dart';

class ConfidenceIndicator extends StatelessWidget {
  final double confidence;

  const ConfidenceIndicator({super.key, required this.confidence});

  Color _color() {
    if (confidence >= .85) return Colors.green;

    if (confidence >= .60) return Colors.orange;

    return Colors.red;
  }

  String _label() {
    if (confidence >= .90) return "Very High";

    if (confidence >= .75) return "High";

    if (confidence >= .60) return "Medium";

    return "Low";
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(Icons.psychology_alt_outlined, size: 18, color: _color()),
      backgroundColor: _color().withOpacity(.12),
      label: Text(
        "${_label()} (${(confidence * 100).toStringAsFixed(0)}%)",
        style: TextStyle(color: _color(), fontWeight: FontWeight.w600),
      ),
    );
  }
}
