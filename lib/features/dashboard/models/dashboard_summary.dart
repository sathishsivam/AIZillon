class DashboardSummary {
  final int agents;
  final int workflows;
  final int datasources;
  final int executions;

  DashboardSummary({
    required this.agents,

    required this.workflows,

    required this.datasources,

    required this.executions,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      agents: json["agents"],

      workflows: json["workflows"],

      datasources: json["datasources"],

      executions: json["executions"],
    );
  }
}
