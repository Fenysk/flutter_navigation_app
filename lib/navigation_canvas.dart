import 'package:flutter/material.dart';
import 'package:navigation_training/config/canvas_style.dart';
import 'package:navigation_training/data/canvas_data.dart';
import 'package:navigation_training/services/canvas_service.dart';

class NavigationCanvas extends CustomPainter {
  NavigationCanvas() {
    CanvasData.clearData();
    CanvasData.generateMap();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, CanvasStyle.canvasBorderStyle);

    CanvasService.drawAllNodes(canvas);
    CanvasService.drawAllRoutes(
      canvas,
      shouldDrawDistance: true,
      shouldDrawLabel: false,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
