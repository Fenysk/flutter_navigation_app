import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navigation_training/config/canvas_style.dart';
import 'package:navigation_training/data/canvas_data.dart';
import 'package:navigation_training/services/navigation_service.dart';

class CanvasService {
  static final CanvasService _instance = CanvasService._internal();
  factory CanvasService() => _instance;
  CanvasService._internal();

  static const double nodeRadius = 5;

  static bool isMouseOverNode(Offset mousePosition, Offset nodePosition) {
    final distance = (mousePosition - nodePosition).distance;
    return distance <= nodeRadius;
  }

  static void drawNodeWithLabel(Canvas canvas, Offset position, String label) {
    final isSelected = NavigationService().isNodeSelected(position);

    canvas.drawCircle(position, isSelected ? nodeRadius + 3 : nodeRadius, isSelected ? CanvasStyle.selectedNodeStyle : CanvasStyle.nodeStyle);

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

    final int distance = NavigationService.calculateDistance(end, start);
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

  static void drawShortestPath(Canvas canvas, List<Offset> path) {
    if (path.length < 2) return;

    for (int i = 0; i < path.length - 1; i++) {
      canvas.drawLine(path[i], path[i + 1], CanvasStyle.shortestPathStyle);
    }
  }

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

  static void onNodeHover(PointerHoverEvent event) {
    for (final node in CanvasData.nodes.entries) {
      if (CanvasService.isMouseOverNode(event.localPosition, node.key)) {
        // print('Hovering over node: ${node.value}');
      }
    }
  }

  static void onNodeTap(TapDownDetails details) {
    for (final node in CanvasData.nodes.entries) {
      if (CanvasService.isMouseOverNode(details.localPosition, node.key)) {
        NavigationService().setNavigationPoint(node.key);
        List<String> shortestPath = NavigationService().getShortestPathNodeLabels();
        print(shortestPath);
        break;
      }
    }
  }
}
