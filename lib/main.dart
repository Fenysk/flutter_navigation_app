import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navigation_training/navigation_canvas.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
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
                painter: NavigationCanvas(),
                size: const Size(1000, 1000),
              ),
              MouseRegion(
                child: GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    final position = details.localPosition;
                    Clipboard.setData(
                      ClipboardData(text: 'Offset(${position.dx.round()}, ${position.dy.round()})'),
                    );
                    print('Coordonnées copiées: ${position.dx}, ${position.dy}');
                  },
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
