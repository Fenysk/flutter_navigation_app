import 'package:flutter/material.dart';
import 'package:navigation_training/navigation_canvas.dart';
import 'package:navigation_training/services/canvas_service.dart';
import 'package:navigation_training/services/navigation_service.dart';
import 'package:navigation_training/widgets/navigation_data_display.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _navigationService = NavigationService();
    _navigationService.addListener(_onNavigationChanged);
  }

  void _onNavigationChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _navigationService.removeListener(_onNavigationChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            NavigationDataDisplay(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  fit: BoxFit.contain,
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
                          navigationService: _navigationService,
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
            ),
          ],
        ),
      ),
    );
  }
}
