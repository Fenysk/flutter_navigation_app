import 'dart:convert';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class CanvasData {
  static const String _nodesKey = 'nodes_data';
  static const String _routesKey = 'routes_data';

  static Map<Offset, String> nodes = {};

  static List<
      (
        Offset,
        Offset,
        String
      )> routes = [];

  static void addNode({
    required Offset position,
    required String nodeName,
  }) {
    nodes[position] = nodeName;
    saveData();
  }

  static void addRoute({
    required Offset offset1,
    required Offset offset2,
    required String nodeName1,
    required String nodeName2,
    required String routeName,
  }) {
    if (!nodes.containsKey(offset1)) {
      addNode(position: offset1, nodeName: nodeName1);
    }
    if (!nodes.containsKey(offset2)) {
      addNode(position: offset2, nodeName: nodeName2);
    }
    routes.add((
      offset1,
      offset2,
      routeName
    ));
    saveData();
  }

  static void createNodeWithConnections({
    required Offset position,
    required String nodeName,
    required List<Offset> selectedNodes,
  }) {
    CanvasData.addNode(
      position: position,
      nodeName: nodeName,
    );

    for (var selectedNode in selectedNodes) {
      final existingNodeName = CanvasData.nodes[selectedNode]!;
      CanvasData.addRoute(
        offset1: selectedNode,
        offset2: position,
        nodeName1: existingNodeName,
        nodeName2: nodeName,
        routeName: '$existingNodeName-$nodeName',
      );
    }
  }

  static void clearData() {
    nodes.clear();
    routes.clear();
    saveData();
  }

  static void generateMap() {
    addRoute(
      offset1: const Offset(402, 310),
      offset2: const Offset(487, 490),
      nodeName1: 'London',
      nodeName2: 'Paris',
      routeName: 'London-Paris',
    );

    addRoute(
      offset1: const Offset(802, 323),
      offset2: const Offset(778, 821),
      nodeName1: 'Berlin',
      nodeName2: 'Rome',
      routeName: 'Berlin-Rome',
    );

    addRoute(
      offset1: const Offset(402, 310),
      offset2: const Offset(802, 323),
      nodeName1: 'London',
      nodeName2: 'Berlin',
      routeName: 'London-Berlin',
    );

    addRoute(
      offset1: const Offset(211, 799),
      offset2: const Offset(402, 310),
      nodeName1: 'Madrid',
      nodeName2: 'London',
      routeName: 'Madrid-London',
    );

    addRoute(
      offset1: const Offset(538, 625),
      offset2: const Offset(487, 490),
      nodeName1: 'Lyon',
      nodeName2: 'Paris',
      routeName: 'Lyon - Paris',
    );

    addRoute(
      offset1: const Offset(538, 625),
      offset2: const Offset(592, 738),
      nodeName1: 'Lyon',
      nodeName2: 'Marseille',
      routeName: 'Lyon-Marseille',
    );

    addRoute(
      offset1: const Offset(562, 403),
      offset2: const Offset(487, 490),
      nodeName1: 'Bruxelle',
      nodeName2: 'Paris',
      routeName: 'Bruxelle-Paris',
    );

    addRoute(
      offset1: const Offset(562, 403),
      offset2: const Offset(802, 323),
      nodeName1: 'Bruxelle',
      nodeName2: 'Berlin',
      routeName: 'Bruxelle-Berlin',
    );

    addRoute(
      offset1: const Offset(350, 620),
      offset2: const Offset(487, 490),
      nodeName1: 'Bordeaux',
      nodeName2: 'Paris',
      routeName: 'Bordeaux-Paris',
    );

    addRoute(
      offset1: const Offset(350, 620),
      offset2: const Offset(211, 799),
      nodeName1: 'Bordeaux',
      nodeName2: 'Madrid',
      routeName: 'Bordeaux-Madrid',
    );

    addRoute(
      offset1: const Offset(350, 620),
      offset2: const Offset(592, 738),
      nodeName1: 'Bordeaux',
      nodeName2: 'Marseille',
      routeName: 'Bordeaux-Marseille',
    );

    addRoute(
      offset1: const Offset(211, 799),
      offset2: const Offset(592, 738),
      nodeName1: 'Madrid',
      nodeName2: 'Marseille',
      routeName: 'Madrid-Marseille',
    );

    addRoute(
      offset1: const Offset(592, 738),
      offset2: const Offset(778, 821),
      nodeName1: 'Marseille',
      nodeName2: 'Rome',
      routeName: 'Marseille-Rome',
    );

    addRoute(
      offset1: const Offset(658, 595),
      offset2: const Offset(778, 821),
      nodeName1: 'Zurich',
      nodeName2: 'Rome',
      routeName: 'Zurich-Rome',
    );

    addRoute(
      offset1: const Offset(658, 595),
      offset2: const Offset(538, 625),
      nodeName1: 'Zurich',
      nodeName2: 'Lyon',
      routeName: 'Zurich-Lyon',
    );

    addRoute(
      offset1: const Offset(658, 595),
      offset2: const Offset(802, 323),
      nodeName1: 'Zurich',
      nodeName2: 'Berlin',
      routeName: 'Berlin-Zurich',
    );
  }

  static Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    final nodesData = nodes.map((key, value) => MapEntry('${key.dx},${key.dy}', value));

    final routesData = routes
        .map((route) => {
              'start': '${route.$1.dx},${route.$1.dy}',
              'end': '${route.$2.dx},${route.$2.dy}',
              'name': route.$3,
            })
        .toList();

    await prefs.setString(_nodesKey, jsonEncode(nodesData));
    await prefs.setString(_routesKey, jsonEncode(routesData));
  }

  static Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final nodesString = prefs.getString(_nodesKey);
    final routesString = prefs.getString(_routesKey);

    if (nodesString != null) {
      final Map<String, dynamic> nodesData = jsonDecode(nodesString);
      nodes.clear();
      nodesData.forEach((key, value) {
        final coordinates = key.split(',');
        final offset = Offset(double.parse(coordinates[0]), double.parse(coordinates[1]));
        nodes[offset] = value;
      });
    }

    if (routesString != null) {
      final List<dynamic> routesData = jsonDecode(routesString);
      routes.clear();
      for (var route in routesData) {
        final startCoords = route['start'].split(',');
        final endCoords = route['end'].split(',');
        routes.add((
          Offset(double.parse(startCoords[0]), double.parse(startCoords[1])),
          Offset(double.parse(endCoords[0]), double.parse(endCoords[1])),
          route['name']
        ));
      }
    }
  }
}
