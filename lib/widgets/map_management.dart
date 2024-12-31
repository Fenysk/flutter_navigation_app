import 'package:flutter/material.dart';
import 'package:navigation_training/data/canvas_data.dart';

class MapManagement extends StatefulWidget {
  final VoidCallback refreshCanvas;

  const MapManagement({
    super.key,
    required this.refreshCanvas,
  });

  @override
  State<MapManagement> createState() => _MapManagementState();
}

class _MapManagementState extends State<MapManagement> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNodesSection(),
          const SizedBox(height: 16),
          _buildRoutesSection(),
        ],
      ),
    );
  }

  Widget _buildNodesSection() {
    return _buildSection('Nodes:', _buildNodesList());
  }

  Widget _buildRoutesSection() {
    return _buildSection('Routes:', _buildRoutesList());
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _formatCoordinates(Offset position) {
    return '(${position.dx.toStringAsFixed(1)}, ${position.dy.toStringAsFixed(1)})';
  }

  List<Widget> _buildNodesList() {
    return CanvasData.nodes.entries.map((node) {
      return _buildNodeListItem(node);
    }).toList();
  }

  Widget _buildNodeListItem(MapEntry<Offset, String> node) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text('${node.value} ${_formatCoordinates(node.key)}'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteNode(node.key),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRoutesList() {
    return CanvasData.routes.map((route) {
      return _buildRouteListItem(route);
    }).toList();
  }

  Widget _buildRouteListItem(
      (
        Offset,
        Offset,
        String
      ) route) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${route.$3} ${_formatCoordinates(route.$1)} -> ${_formatCoordinates(route.$2)}',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteRoute(route),
          ),
        ],
      ),
    );
  }

  void _deleteRoute(
      (
        Offset,
        Offset,
        String
      ) route) {
    setState(() {
      CanvasData.removeRoute(start: route.$1, end: route.$2);
      widget.refreshCanvas();
    });
  }

  void _deleteNode(Offset nodePosition) {
    setState(() {
      CanvasData.removeNode(nodePosition);
      widget.refreshCanvas();
    });
  }
}
