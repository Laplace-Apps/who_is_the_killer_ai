import 'dart:convert';

import 'package:flutter/services.dart';

class MapRect {
  const MapRect({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  final double x;
  final double y;
  final double w;
  final double h;

  factory MapRect.fromJson(Map<String, dynamic> json) {
    return MapRect(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      w: (json['w'] as num).toDouble(),
      h: (json['h'] as num).toDouble(),
    );
  }

  bool containsPoint(double px, double py) {
    return px >= x && px <= x + w && py >= y && py <= y + h;
  }

  bool overlaps(MapRect other) {
    return x < other.x + other.w &&
        x + w > other.x &&
        y < other.y + other.h &&
        y + h > other.y;
  }
}

class MapPoint {
  const MapPoint({required this.x, required this.y});

  final double x;
  final double y;

  factory MapPoint.fromJson(Map<String, dynamic> json) {
    return MapPoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }
}

class MapPortal {
  const MapPortal({
    required this.to,
    required this.bounds,
    required this.requiresUnlock,
    this.requiredClueIds = const [],
  });

  final String to;
  final MapRect bounds;
  final bool requiresUnlock;
  final List<String> requiredClueIds;

  factory MapPortal.fromJson(Map<String, dynamic> json) {
    return MapPortal(
      to: json['to'] as String,
      bounds: MapRect(
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        w: (json['w'] as num).toDouble(),
        h: (json['h'] as num).toDouble(),
      ),
      requiresUnlock: json['requiresUnlock'] as bool? ?? false,
      requiredClueIds: List<String>.from(json['requiredClueIds'] as List? ?? []),
    );
  }
}

class MapClueSpot {
  const MapClueSpot({
    required this.id,
    required this.x,
    required this.y,
    required this.labelEn,
    required this.labelTr,
    this.prop = 'chest',
  });

  final String id;
  final double x;
  final double y;
  final String labelEn;
  final String labelTr;
  final String prop;

  factory MapClueSpot.fromJson(Map<String, dynamic> json) {
    return MapClueSpot(
      id: json['id'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      labelEn: json['labelEn'] as String,
      labelTr: json['labelTr'] as String,
      prop: json['prop'] as String? ?? 'chest',
    );
  }
}

class MapRoom {
  const MapRoom({
    required this.id,
    required this.nameEn,
    required this.nameTr,
    required this.width,
    required this.height,
    required this.floorColor,
    required this.accentColor,
    required this.spawn,
    required this.walls,
    required this.portals,
    required this.clues,
  });

  final String id;
  final String nameEn;
  final String nameTr;
  final double width;
  final double height;
  final String floorColor;
  final String accentColor;
  final MapPoint spawn;
  final List<MapRect> walls;
  final List<MapPortal> portals;
  final List<MapClueSpot> clues;

  factory MapRoom.fromJson(Map<String, dynamic> json) {
    return MapRoom(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
      nameTr: json['nameTr'] as String,
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      floorColor: json['floorColor'] as String,
      accentColor: json['accentColor'] as String,
      spawn: MapPoint.fromJson(json['spawn'] as Map<String, dynamic>),
      walls: (json['walls'] as List)
          .map((w) => MapRect.fromJson(w as Map<String, dynamic>))
          .toList(),
      portals: (json['portals'] as List)
          .map((p) => MapPortal.fromJson(p as Map<String, dynamic>))
          .toList(),
      clues: (json['clues'] as List)
          .map((c) => MapClueSpot.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ObservatoryMapLayout {
  const ObservatoryMapLayout({
    required this.startRoomId,
    required this.defaultUnlocked,
    required this.rooms,
  });

  final String startRoomId;
  final List<String> defaultUnlocked;
  final Map<String, MapRoom> rooms;

  factory ObservatoryMapLayout.fromJson(Map<String, dynamic> json) {
    final roomsJson = json['rooms'] as Map<String, dynamic>;
    final rooms = <String, MapRoom>{};
    for (final entry in roomsJson.entries) {
      rooms[entry.key] =
          MapRoom.fromJson(entry.value as Map<String, dynamic>);
    }
    return ObservatoryMapLayout(
      startRoomId: json['startRoomId'] as String,
      defaultUnlocked: List<String>.from(json['defaultUnlocked'] as List),
      rooms: rooms,
    );
  }

  static Future<ObservatoryMapLayout> load() async {
    final raw = await rootBundle.loadString(
      'assets/cases/whispering_observatory/map_layout.json',
    );
    return ObservatoryMapLayout.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }
}

class NpcWaypoint {
  const NpcWaypoint({
    required this.roomId,
    required this.x,
    required this.y,
  });

  final String roomId;
  final double x;
  final double y;

  factory NpcWaypoint.fromJson(Map<String, dynamic> json) {
    return NpcWaypoint(
      roomId: json['roomId'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }
}

class NpcRoute {
  const NpcRoute({
    required this.suspectId,
    required this.homeRoom,
    required this.waypoints,
    required this.speed,
  });

  final String suspectId;
  final String homeRoom;
  final List<NpcWaypoint> waypoints;
  final double speed;

  factory NpcRoute.fromJson(String suspectId, Map<String, dynamic> json) {
    return NpcRoute(
      suspectId: suspectId,
      homeRoom: json['homeRoom'] as String,
      waypoints: (json['waypoints'] as List)
          .map((w) => NpcWaypoint.fromJson(w as Map<String, dynamic>))
          .toList(),
      speed: (json['speed'] as num).toDouble(),
    );
  }
}

class NpcRoutesData {
  const NpcRoutesData({required this.routes});

  final Map<String, NpcRoute> routes;

  static Future<NpcRoutesData> load() async {
    final raw = await rootBundle.loadString(
      'assets/cases/whispering_observatory/npc_routes.json',
    );
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final routesJson = json['routes'] as Map<String, dynamic>;
    final routes = <String, NpcRoute>{};
    for (final entry in routesJson.entries) {
      routes[entry.key] =
          NpcRoute.fromJson(entry.key, entry.value as Map<String, dynamic>);
    }
    return NpcRoutesData(routes: routes);
  }
}
