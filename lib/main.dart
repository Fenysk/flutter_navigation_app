import 'package:flutter/material.dart';
import 'package:navigation_training/data/canvas_data.dart';
import 'package:navigation_training/services/navigation_service.dart';
import 'package:navigation_training/widgets/add_node_dialog.dart';
import 'package:navigation_training/widgets/map_management.dart';
import 'package:navigation_training/widgets/navigation_data_display.dart';
import 'package:navigation_training/widgets/node_widget.dart';
import 'package:navigation_training/widgets/route_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final NavigationService _navigationService = NavigationService();

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _setupNavigationListener();
  }

  void _initializeMap() => CanvasData.generateMap();
  void _setupNavigationListener() => _navigationService.addListener(_onNavigationChanged);
  void _onNavigationChanged() => setState(() {});

  @override
  void dispose() {
    _navigationService.removeListener(_onNavigationChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(builder: (context) {
          return Row(
            children: [
              SizedBox(
                width: 300,
                child: NavigationDataDisplay(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: GestureDetector(
                      onTapDown: (details) => onMapTap(details, context),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/map.jpg',
                            width: 1000,
                            height: 1000,
                            fit: BoxFit.cover,
                          ),
                          ...CanvasData.routes.map(
                            (route) => RouteWidget(
                              start: route.$1,
                              end: route.$2,
                              label: route.$3,
                              isPartOfShortestPath: _navigationService.findShortestPath().contains(route.$1) && _navigationService.findShortestPath().contains(route.$2),
                            ),
                          ),
                          ...CanvasData.nodes.entries.map(
                            (node) => NodeWidget(
                              position: node.key,
                              label: node.value,
                              isSelected: _navigationService.isNodeSelected(node.key),
                              onTap: () => _navigationService.setNavigationPoint(node.key),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 400,
                child: MapManagement(),
              ),
            ],
          );
        }),
      ),
    );
  }

  void onMapTap(TapDownDetails details, BuildContext context) async {
    final position = details.localPosition;
    final dialogResult = await _showAddNodeDialog(context);

    if (_isValidDialogResult(dialogResult)) {
      CanvasData.createNodeWithConnections(
        position: position,
        nodeName: dialogResult!.$1!,
        selectedNodes: dialogResult.$2,
      );
      setState(() {});
    }
  }

  bool _isValidDialogResult(
          (
            String?,
            List<Offset>
          )? result) =>
      result != null && result.$1 != null && result.$1!.isNotEmpty;

  Future<
      (
        String?,
        List<Offset>
      )?> _showAddNodeDialog(BuildContext context) {
    return showDialog<
        (
          String?,
          List<Offset>
        )>(
      context: context,
      builder: (context) => AddNodeDialog(),
    );
  }
}
