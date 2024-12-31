import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:navigation_training/data/canvas_data.dart';

class NavigationService extends ChangeNotifier {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  Offset? _navigationStart;
  Offset? _navigationEnd;

  set navigationStart(Offset? value) => _navigationStart = value;
  set navigationEnd(Offset? value) => _navigationEnd = value;

  void setNavigationPoint(Offset point) {
    print('Navigation point set: ${CanvasData.nodes[point]}');

    if (_navigationStart == null && _navigationEnd == null) {
      _navigationStart = point;
    } else if (_navigationStart != null && _navigationEnd == null) {
      _navigationEnd = point;
    } else {
      _navigationStart = point;
    }

    List<Offset> aroundNodes = getAroundNodes(point);
    print('Connected nodes: ${aroundNodes.map((node) => CanvasData.nodes[node]).join(', ')}');

    notifyListeners();
  }

  bool isOffsetSelected(Offset offset) {
    return offset == _navigationStart || offset == _navigationEnd;
  }

  static int getDistanceBetweenNodes(Offset end, Offset start) => ((end - start).distance).round();

  List<Offset> getAroundNodes(Offset center) => CanvasData.routes.where((route) => route.$1 == center || route.$2 == center).map((route) => route.$1 == center ? route.$2 : route.$1).toList();
}
