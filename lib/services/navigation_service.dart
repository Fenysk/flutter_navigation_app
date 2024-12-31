import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:navigation_training/data/canvas_data.dart';

class NavigationService extends ChangeNotifier {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  Offset? _navigationStart;
  Offset? _navigationEnd;

  Set<Offset> _nodesToEvaluate = {};
  Set<Offset> _evaluatedNodes = {};
  Map<Offset, Offset> _pathTrace = {};
  Map<Offset, int> _totalCostToNode = {};
  Map<Offset, int> _costFromStartToNode = {};

  Offset? get navigationStart => _navigationStart;
  Offset? get navigationEnd => _navigationEnd;
  Set<Offset> get nodesToEvaluate => _nodesToEvaluate;
  Set<Offset> get evaluatedNodes => _evaluatedNodes;
  Map<Offset, Offset> get pathTrace => _pathTrace;
  Map<Offset, int> get totalCostToNode => _totalCostToNode;
  Map<Offset, int> get costFromStartToNode => _costFromStartToNode;

  bool isNodeSelected(Offset node) => node == _navigationStart || node == _navigationEnd;

  void setNavigationPoint(Offset selectedPoint) {
    _updateNavigationPoints(selectedPoint);
    _logConnectedNodesFromSelectedNode(selectedPoint);

    notifyListeners();
  }

  void _updateNavigationPoints(Offset point) {
    if (_navigationStart == null && _navigationEnd == null) {
      _navigationStart = point;
    } else if (_navigationStart != null && _navigationEnd == null) {
      _navigationEnd = point;
    } else {
      _navigationEnd = null;
      _navigationStart = point;
    }
  }

  void _logConnectedNodesFromSelectedNode(Offset selectedPoint) {
    List<Offset> connectedNodes = getConnectedNodes(selectedPoint);
    print('Connected nodes: ${connectedNodes.map((node) => CanvasData.nodes[node]).join(', ')}');
  }

  List<String> getShortestPathNodeLabels() {
    if (_navigationStart == null || _navigationEnd == null) return [];

    List<Offset> path = findShortestPath();
    List<String> nodeLabels = path.where((node) => CanvasData.nodes.containsKey(node)).map((node) => CanvasData.nodes[node]!).toList();

    return nodeLabels;
  }

  List<Offset> findShortestPath() {
    if (_navigationStart == null || _navigationEnd == null) return [];

    _initializePathfinding();
    List<Offset> path = _executeAStarAlgorithm();

    if (path.isEmpty) {
      CanvasData.addRoute(
        offset1: _navigationStart!,
        offset2: _navigationEnd!,
        nodeName1: CanvasData.nodes[_navigationStart]!,
        nodeName2: CanvasData.nodes[_navigationEnd]!,
        routeName: '${CanvasData.nodes[_navigationStart]}-${CanvasData.nodes[_navigationEnd]}',
      );
      notifyListeners();

      _initializePathfinding();
      path = _executeAStarAlgorithm();
    }

    return path;
  }

  void _initializePathfinding() {
    _nodesToEvaluate = {
      _navigationStart!
    };
    _evaluatedNodes = {};
    _pathTrace = {};
    _costFromStartToNode = {
      _navigationStart!: 0
    };
    _totalCostToNode = {
      _navigationStart!: calculateDistance(_navigationEnd!, _navigationStart!)
    };
  }

  List<Offset> _executeAStarAlgorithm() {
    while (_nodesToEvaluate.isNotEmpty) {
      Offset currentNode = _findNodeWithLowestTotalCost();

      if (currentNode == _navigationEnd) {
        List<Offset> path = _reconstructPath(currentNode);
        return path;
      }

      _evaluateNode(currentNode);
    }

    return [];
  }

  void _evaluateNode(Offset currentNode) {
    _nodesToEvaluate.remove(currentNode);
    _evaluatedNodes.add(currentNode);

    for (Offset neighbor in getConnectedNodes(currentNode)) {
      if (_evaluatedNodes.contains(neighbor)) continue;

      int costToNeighbor = _costFromStartToNode[currentNode]! + calculateDistance(neighbor, currentNode);

      if (!_nodesToEvaluate.contains(neighbor)) {
        _nodesToEvaluate.add(neighbor);
      } else if (costToNeighbor >= (_costFromStartToNode[neighbor] ?? double.infinity)) {
        continue;
      }

      _updateNodeCosts(neighbor, currentNode, costToNeighbor);
    }
  }

  void _updateNodeCosts(Offset neighbor, Offset currentNode, int costToNeighbor) {
    _pathTrace[neighbor] = currentNode;
    _costFromStartToNode[neighbor] = costToNeighbor;
    _totalCostToNode[neighbor] = costToNeighbor + calculateDistance(_navigationEnd!, neighbor);
  }

  List<Offset> _reconstructPath(Offset endNode) {
    List<Offset> path = [
      endNode
    ];
    Offset currentNode = endNode;

    while (_pathTrace.containsKey(currentNode)) {
      currentNode = _pathTrace[currentNode]!;
      path.insert(0, currentNode);
    }

    return path;
  }

  Offset _findNodeWithLowestTotalCost() => _nodesToEvaluate.reduce((a, b) => _totalCostToNode[a]! < _totalCostToNode[b]! ? a : b);
  List<Offset> getConnectedNodes(Offset center) => CanvasData.routes.where((route) => route.$1 == center || route.$2 == center).map((route) => route.$1 == center ? route.$2 : route.$1).toList();
  static int calculateDistance(Offset end, Offset start) => ((end - start).distance).round();
}
