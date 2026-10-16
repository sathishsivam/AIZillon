import 'package:flutter/foundation.dart';

@immutable
class HitlStep {
  final String businessTerm;

  final String message;

  final List<HitlCandidate> candidates;

  final HitlCandidate? recommended;

  final HitlCandidate? selected;

  final bool completed;

  const HitlStep({
    required this.businessTerm,
    required this.message,
    required this.candidates,
    this.recommended,
    this.selected,
    this.completed = false,
  });

  bool get waitingForUser => !completed;

  bool get hasRecommendation => recommended != null;

  bool get hasSelection => selected != null;
}

@immutable
class HitlCandidate {
  final String column;

  final String businessName;

  final double confidence;

  final String reason;

  const HitlCandidate({
    required this.column,
    required this.businessName,
    required this.confidence,
    required this.reason,
  });
}
