import 'package:flutter/material.dart';
import 'package:navigation_training/services/navigation_service.dart';

class NavigationDataDisplay extends StatelessWidget {
  const NavigationDataDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationService navigationService = NavigationService();
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDataRow('Navigation Start', navigationService.navigationStart?.toString() ?? 'Not set'),
          _buildDataRow('Navigation End', navigationService.navigationEnd?.toString() ?? 'Not set'),
          _buildDataRow('Nodes to Evaluate', navigationService.nodesToEvaluate.length.toString()),
          _buildDataRow('Evaluated Nodes', navigationService.evaluatedNodes.length.toString()),
          _buildDataRow('Path Trace', navigationService.pathTrace.length.toString()),
          _buildDataRow('Total Cost to Nodes', navigationService.totalCostToNode.length.toString()),
          _buildDataRow('Cost from Start to Nodes', navigationService.costFromStartToNode.length.toString()),
          if (navigationService.navigationStart != null && navigationService.navigationEnd != null) _buildDataRow('Shortest Path', navigationService.getShortestPathNodeLabels().join(' → ')),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
