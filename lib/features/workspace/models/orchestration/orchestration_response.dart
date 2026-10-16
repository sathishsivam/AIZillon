class OrchestrationSource {
  final String type;
  final String name;
  final Map<String, dynamic> metadata;

  const OrchestrationSource({
    required this.type,
    required this.name,
    this.metadata = const {},
  });

  factory OrchestrationSource.fromJson(Map<String, dynamic> json) {
    return OrchestrationSource(
      type: json["type"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      metadata:
          json["metadata"] is Map
              ? Map<String, dynamic>.from(json["metadata"])
              : {},
    );
  }
}

class OrchestrationResponse {
  final bool success;
  final String? intent;
  final String? strategy;
  final String? response;
  final List<OrchestrationSource> sources;
  final bool requiresAuthentication;
  final bool requiresConfirmation;
  final String? confirmationId;
  final String? clarificationQuestion;
  final String? error;

  const OrchestrationResponse({
    required this.success,
    this.intent,
    this.strategy,
    this.response,
    this.sources = const [],
    this.requiresAuthentication = false,
    this.requiresConfirmation = false,
    this.confirmationId,
    this.clarificationQuestion,
    this.error,
  });

  factory OrchestrationResponse.fromJson(Map<String, dynamic> json) {
    final rawSources = json["sources"];

    return OrchestrationResponse(
      success: json["success"] == true,
      intent: json["intent"]?.toString(),
      strategy: json["strategy"]?.toString(),
      response: json["response"]?.toString(),

      sources:
          rawSources is List
              ? rawSources
                  .whereType<Map>()
                  .map(
                    (source) => OrchestrationSource.fromJson(
                      Map<String, dynamic>.from(source),
                    ),
                  )
                  .toList()
              : const [],

      requiresAuthentication: json["requires_authentication"] == true,

      requiresConfirmation: json["requires_confirmation"] == true,

      confirmationId: json["confirmation_id"]?.toString(),

      clarificationQuestion: json["clarification_question"]?.toString(),

      error: json["error"]?.toString(),
    );
  }
}
