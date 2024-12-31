import 'package:flutter/material.dart';
import 'package:navigation_training/data/canvas_data.dart';

class MapManagement extends StatelessWidget {
  const MapManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Nodes:'),
          const SizedBox(height: 8),
          ..._buildNodesList(),
          const SizedBox(height: 16),
          _buildSectionHeader('Routes:'),
          const SizedBox(height: 8),
          ..._buildRoutesList(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  List<Widget> _buildNodesList() {
    return CanvasData.nodes.entries.map((node) {
      final position = node.key;
      final name = node.value;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          '$name (${position.dx.toStringAsFixed(1)}, ${position.dy.toStringAsFixed(1)})',
        ),
      );
    }).toList();
  }

  List<Widget> _buildRoutesList() {
    return CanvasData.routes.map((route) {
      final start = route.$1;
      final end = route.$2;
      final name = route.$3;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          '$name (${start.dx.toStringAsFixed(1)}, ${start.dy.toStringAsFixed(1)}) -> '
          '(${end.dx.toStringAsFixed(1)}, ${end.dy.toStringAsFixed(1)})',
        ),
      );
    }).toList();
  }
}
