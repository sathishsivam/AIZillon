import 'package:flutter/material.dart';
import 'package:aizillon/shared/widgets/cards/metric_card.dart';
import 'package:aizillon/shared/widgets/cards/status_card.dart';

import 'package:aizillon/shared/layouts/responsive_layout.dart';
import 'package:aizillon/features/monitoring/services/health_api.dart';

// class DashboardPage extends StatelessWidget {
//   const DashboardPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    _checkBackend();
  }

  Future<void> _checkBackend() async {
    try {
      final response = await HealthApi().health();

      debugPrint("Backend Response: $response");
    } catch (e) {
      debugPrint("API Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = ResponsiveLayout.dashboardColumns(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: GridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.0,
              children: const [
                MetricCard(
                  icon: Icons.smart_toy,
                  title: "AI Agents",
                  value: "8",
                  subtitle: "",
                  color: Colors.blue,
                ),

                MetricCard(
                  icon: Icons.smart_toy,
                  title: "AI Agents",
                  value: "8",
                  subtitle: "+2 this week",
                  color: Colors.lime,
                ),

                MetricCard(
                  icon: Icons.route,
                  title: "Workflows",
                  value: "14",
                  subtitle: "",
                  color: Colors.orange,
                ),

                MetricCard(
                  icon: Icons.play_circle_fill,
                  title: "Executions",
                  value: "1,240",
                  subtitle: "",
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
