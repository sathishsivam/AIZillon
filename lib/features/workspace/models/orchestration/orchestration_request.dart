class OrchestrationRequest {
  final String query;
  final String? sessionId;
  final Map<String, dynamic>? userContext;

  const OrchestrationRequest({
    required this.query,
    this.sessionId,
    this.userContext,
  });

  Map<String, dynamic> toJson() {
    return {
      "query": query,
      if (sessionId != null) "session_id": sessionId,
      if (userContext != null) "user_context": userContext,
    };
  }
}
