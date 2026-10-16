import 'package:flutter/material.dart';

class DecisionConfirmationCard extends StatelessWidget {
  final String selectedColumn;

  const DecisionConfirmationCard({super.key, required this.selectedColumn});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Decision",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "You selected '$selectedColumn' as the correct business column.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
