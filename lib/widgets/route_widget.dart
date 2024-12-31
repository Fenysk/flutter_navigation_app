import 'package:flutter/material.dart';

class RouteWidget extends StatelessWidget {
  final Offset start;
  final Offset end;
  final String label;
  final bool isPartOfShortestPath;

  const RouteWidget({
    super.key,
    required this.start,
    required this.end,
    required this.label,
    this.isPartOfShortestPath = false,
  });

  @override
  Widget build(BuildContext context) {
    final midpoint = Offset(
      (start.dx + end.dx) / 2,
      (start.dy + end.dy) / 2,
    );

    return CustomPaint(
      size: const Size(1000, 1000),
      painter: _RoutePainter(
        start: start,
        end: end,
        label: label,
        midpoint: midpoint,
        isPartOfShortestPath: isPartOfShortestPath,
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final String label;
  final Offset midpoint;
  final bool isPartOfShortestPath;

  _RoutePainter({
    required this.start,
    required this.end,
    required this.label,
    required this.midpoint,
    required this.isPartOfShortestPath,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isPartOfShortestPath ? Colors.purple : Colors.blue
      ..strokeWidth = isPartOfShortestPath ? 3.0 : 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);

    final textSpan = TextSpan(
      text: label,
      style: const TextStyle(
        color: Colors.blue,
        fontSize: 10,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(midpoint.dx - textPainter.width / 2, midpoint.dy),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
