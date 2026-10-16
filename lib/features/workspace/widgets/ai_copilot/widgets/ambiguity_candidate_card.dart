import 'package:flutter/material.dart';

import '../models/hitl_step.dart';
import 'candidate_score_bar.dart';

class AmbiguityCandidateCard extends StatelessWidget {
  final HitlCandidate candidate;

  final bool recommended;

  final bool selected;

  final VoidCallback? onSelect;

  const AmbiguityCandidateCard({
    super.key,
    required this.candidate,
    this.recommended = false,
    this.selected = false,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: selected ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? Colors.orange : Colors.grey.shade300,
          width: selected ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //--------------------------------------------------
            // Header
            //--------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: Text(
                    candidate.column,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                if (recommended)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "AI Recommended",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 18),

            //--------------------------------------------------
            // Business Name
            //--------------------------------------------------
            Row(
              children: [
                const Icon(
                  Icons.business_center_outlined,
                  color: Colors.blueGrey,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    candidate.businessName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            //--------------------------------------------------
            // Confidence
            //--------------------------------------------------
            CandidateScoreBar(confidence: candidate.confidence),

            const SizedBox(height: 20),

            //--------------------------------------------------
            // Reason
            //--------------------------------------------------
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.orange),

                  const SizedBox(width: 10),

                  Expanded(child: Text(candidate.reason)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            //--------------------------------------------------
            // Button
            //--------------------------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(selected ? Icons.check_circle : Icons.touch_app),
                label: Text(selected ? "Selected" : "Choose this Column"),
                onPressed: selected ? null : onSelect,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
