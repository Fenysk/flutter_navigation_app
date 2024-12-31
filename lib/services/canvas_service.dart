import 'package:flutter/material.dart';
import 'package:navigation_training/config/canvas_style.dart';
import 'package:navigation_training/data/canvas_data.dart';

class CanvasService {
  static void drawNodeWithLabel(Canvas canvas, Offset position, String label) {
    canvas.drawCircle(position, 5, CanvasStyle.nodeStyle);
    final textSpan = TextSpan(text: label, style: CanvasStyle.nodeTextStyle);
    final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    final textOffset = Offset(position.dx - textPainter.width / 2, position.dy - 20);
    textPainter.paint(canvas, textOffset);
  }

  static void drawRouteWithLabel(
    Canvas canvas,
    Offset start,
    Offset end,
    String label,
    bool shouldDrawLabel,
    bool shouldDrawDistance,
  ) {
    canvas.drawLine(start, end, CanvasStyle.routeStyle);
    final midpoint = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);

    final int distance = getDistanceBetweenNodes(end, start);
    String displayText = '';

    if (shouldDrawLabel && shouldDrawDistance) {
      displayText = '$label (';
      final textSpan = TextSpan(
        children: [
          TextSpan(text: displayText, style: CanvasStyle.routeTextStyle),
          TextSpan(text: distance.toString(), style: CanvasStyle.routeTextStyle.copyWith(fontWeight: FontWeight.bold)),
          TextSpan(text: ')', style: CanvasStyle.routeTextStyle),
        ],
      );
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      final textOffset = Offset(midpoint.dx - textPainter.width / 2, midpoint.dy);
      textPainter.paint(canvas, textOffset);
    } else if (shouldDrawLabel) {
      final textSpan = TextSpan(text: label, style: CanvasStyle.routeTextStyle);
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      final textOffset = Offset(midpoint.dx - textPainter.width / 2, midpoint.dy);
      textPainter.paint(canvas, textOffset);
    } else if (shouldDrawDistance) {
      final textSpan = TextSpan(
        text: distance.toString(),
        style: CanvasStyle.routeTextStyle.copyWith(fontWeight: FontWeight.bold),
      );
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      final textOffset = Offset(midpoint.dx - textPainter.width / 2, midpoint.dy);
      textPainter.paint(canvas, textOffset);
    }
  }

  static int getDistanceBetweenNodes(Offset end, Offset start) => ((end - start).distance).round();

  static void drawAllNodes(Canvas canvas) {
    for (final node in CanvasData.nodes.entries) {
      drawNodeWithLabel(canvas, node.key, node.value);
    }
  }

  static void drawAllRoutes(
    Canvas canvas, {
    bool shouldDrawLabel = true,
    bool shouldDrawDistance = true,
  }) {
    for (final route in CanvasData.routes) {
      drawRouteWithLabel(canvas, route.$1, route.$2, route.$3, shouldDrawLabel, shouldDrawDistance);
    }
  }
}
