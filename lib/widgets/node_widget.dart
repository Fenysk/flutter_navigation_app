import 'package:flutter/material.dart';

class NodeWidget extends StatefulWidget {
  final Offset position;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NodeWidget({
    super.key,
    required this.position,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      left: widget.position.dx - (isHovered ? 7.5 : 5),
      top: widget.position.dy - (isHovered ? 22.5 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isHovered ? 15 : 10,
                height: isHovered ? 15 : 10,
                decoration: BoxDecoration(
                  color: widget.isSelected ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
