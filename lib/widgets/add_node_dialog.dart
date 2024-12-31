import 'package:flutter/material.dart';
import 'package:navigation_training/data/canvas_data.dart';

class AddNodeDialog extends StatefulWidget {
  const AddNodeDialog({super.key});

  @override
  State<AddNodeDialog> createState() => _AddNodeDialogState();
}

class _AddNodeDialogState extends State<AddNodeDialog> {
  String _nodeName = '';
  final List<Offset> _selectedNodes = [];
  String _searchQuery = '';

  List<MapEntry<Offset, String>> get _filteredNodes => CanvasData.nodes.entries.where((node) => node.value.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Node'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNodeNameInput(),
            const SizedBox(height: 16),
            const Text('Link with nodes:'),
            _buildSearchInput(),
            const SizedBox(height: 8),
            _buildNodesList(),
          ],
        ),
      ),
      actions: _buildDialogActions(context),
    );
  }

  TextField _buildNodeNameInput() {
    return TextField(
      autofocus: true,
      onChanged: (value) => _nodeName = value,
      decoration: const InputDecoration(
        hintText: 'Enter node name',
      ),
    );
  }

  TextField _buildSearchInput() {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search nodes...',
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        setState(() => _searchQuery = value);
      },
    );
  }

  Widget _buildNodesList() {
    return Container(
      height: 150,
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListView.builder(
        itemCount: _filteredNodes.length,
        itemBuilder: _buildNodeListItem,
      ),
    );
  }

  Widget _buildNodeListItem(BuildContext context, int index) {
    final node = _filteredNodes[index];
    return CheckboxListTile(
      title: Text(node.value),
      value: _selectedNodes.contains(node.key),
      onChanged: (bool? value) {
        setState(() {
          if (value == true) {
            _selectedNodes.add(node.key);
          } else {
            _selectedNodes.remove(node.key);
          }
        });
      },
    );
  }

  List<Widget> _buildDialogActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, (
          _nodeName,
          _selectedNodes
        )),
        child: const Text('OK'),
      ),
    ];
  }
}
