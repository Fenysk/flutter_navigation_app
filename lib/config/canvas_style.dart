import 'package:flutter/material.dart';

class CanvasStyle {
  static final Paint canvasBorderStyle = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  static final Paint nodeStyle = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill;

  static final Paint routeStyle = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  static final TextStyle nodeTextStyle = TextStyle(
    color: Colors.red,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle routeTextStyle = TextStyle(
    color: Colors.blue,
    fontSize: 10,
  );
}