import 'package:flutter/material.dart';
import 'package:navigation_training/navigation_canvas.dart';
import 'package:navigation_training/services/canvas_service.dart';
import 'package:navigation_training/services/navigation_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    final navigationService = NavigationService();

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Image.asset(
                'assets/map.jpg',
                width: 1000,
                height: 1000,
                fit: BoxFit.cover,
              ),
              CustomPaint(
                painter: NavigationCanvas(
                  navigationService: navigationService,
                ),
                size: const Size(1000, 1000),
              ),
              MouseRegion(
                onHover: CanvasService.onNodeHover,
                child: GestureDetector(
                  onTapDown: CanvasService.onNodeTap,
                  child: Container(
                    width: 1000,
                    height: 1000,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
