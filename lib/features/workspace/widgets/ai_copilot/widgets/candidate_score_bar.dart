import 'package:flutter/material.dart';

class CandidateScoreBar extends StatelessWidget {
  final double confidence;

  const CandidateScoreBar({super.key, required this.confidence});

  Color _color(double score) {
    if (score >= 0.85) return Colors.green;
    if (score >= 0.60) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final percent = (confidence * 100).clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: confidence.clamp(0.0, 1.0),
          minHeight: 8,
          borderRadius: BorderRadius.circular(20),
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation(_color(confidence)),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "${percent.toStringAsFixed(0)}%",
            style: TextStyle(
              color: _color(confidence),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
