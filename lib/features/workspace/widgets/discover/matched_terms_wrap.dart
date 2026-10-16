import 'package:flutter/material.dart';

class MatchedTermsWrap extends StatelessWidget {
  final List<String> terms;

  const MatchedTermsWrap({super.key, required this.terms});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: terms.map((e) => Chip(label: Text(e))).toList(),
    );
  }
}
