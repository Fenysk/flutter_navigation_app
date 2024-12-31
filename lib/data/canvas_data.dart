import 'dart:ui';

class CanvasData {
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
}
