import 'package:flutter/material.dart';
import 'package:navigation_training/data/canvas_data.dart';
import 'package:navigation_training/services/navigation_service.dart';
import 'package:navigation_training/widgets/add_node_dialog.dart';
import 'package:navigation_training/widgets/add_route_dialog.dart';
import 'package:navigation_training/widgets/map_management.dart';
import 'package:navigation_training/widgets/navigation_data_display.dart';
import 'package:navigation_training/widgets/node_widget.dart';
import 'package:navigation_training/widgets/route_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    await CanvasData.loadData();
    if (CanvasData.nodes.isEmpty) {
      _initializeMap();
    }
    _setupNavigationListener();
    setState(() {});
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
    final shortestPath = _navigationService.findShortestPath();

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
                      onTapDown: (details) => onCreateNodeTap(details, context),
                      onSecondaryTapDown: (details) => onCreateRouteTap(details, context),
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
                              isPartOfShortestPath: shortestPath.contains(route.$1) && shortestPath.contains(route.$2),
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
                child: MapManagement(
                  refreshCanvas: () => setState(() {}),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void onCreateNodeTap(TapDownDetails details, BuildContext context) async {
    final position = details.localPosition;
    final dialogResult = await _showAddNodeDialog(context);

    if (_isValidAddNodeDialogResult(dialogResult)) {
      CanvasData.createNodeWithConnections(
        position: position,
        nodeName: dialogResult!.$1!,
        selectedNodes: dialogResult.$2,
      );
      setState(() {});
    }
  }

  bool _isValidAddNodeDialogResult(
          (
            String?,
            List<Offset>
          )? result) =>
      result != null && result.$1 != null && result.$1!.isNotEmpty;

  bool _isValidAddRouteDialogResult(
          (
            String?,
            List<Offset>
          )? result) =>
      result != null && result.$2.isNotEmpty;

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

  Future<
      (
        String?,
        List<Offset>
      )?> _showAddRouteDialog(BuildContext context) {
    return showDialog<
        (
          String?,
          List<Offset>
        )>(
      context: context,
      builder: (context) => AddRouteDialog(),
    );
  }

  void onCreateRouteTap(TapDownDetails details, BuildContext context) async {
    final position = details.localPosition;
    final nearestNode = CanvasData.findNearestNode(position);
    if (nearestNode == null) return;

    final dialogResult = await _showAddRouteDialog(context);

    if (_isValidAddRouteDialogResult(dialogResult)) {
      for (var selectedNode in dialogResult!.$2) {
        if (selectedNode != nearestNode) {
          CanvasData.addRoute(
            offset1: selectedNode,
            offset2: nearestNode,
            nodeName1: CanvasData.nodes[selectedNode]!,
            nodeName2: CanvasData.nodes[nearestNode]!,
            routeName: '${CanvasData.nodes[selectedNode]!}-${CanvasData.nodes[nearestNode]!}',
          );
        }
      }
      setState(() {});
    }
  }
}
