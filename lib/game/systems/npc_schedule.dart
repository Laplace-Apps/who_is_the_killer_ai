import '../data/map_models.dart';

/// Story-beat aware NPC presence. Culls off-room routes so only NPCs that
/// belong in [currentRoomId] (or share a waypoint there) are spawned.
class NpcSchedule {
  const NpcSchedule({required this.routes});

  final Map<String, NpcRoute> routes;

  /// Returns a room-local route (waypoints filtered to [roomId]) or null if
  /// the suspect should not appear in this room for the current beat.
  NpcRoute? routeForRoom({
    required String suspectId,
    required String roomId,
    required int discoveredClueCount,
  }) {
    final full = routes[suspectId];
    if (full == null) return null;

    // Late-game: Silas may patrol server after shaft discovery pressure.
    if (suspectId == 'suspect_05' &&
        roomId == 'location_06' &&
        discoveredClueCount < 1) {
      return null;
    }

    // Catwalk is outdoor / late unlock — only show Elena there after clue_07 era.
    if (roomId == 'location_08' &&
        suspectId != 'suspect_01' &&
        discoveredClueCount < 2) {
      return null;
    }

    final inRoom = full.waypoints.where((w) => w.roomId == roomId).toList();
    if (inRoom.isEmpty && full.homeRoom != roomId) return null;

    return NpcRoute(
      suspectId: full.suspectId,
      homeRoom: full.homeRoom,
      waypoints: inRoom.isEmpty
          ? [
              NpcWaypoint(
                roomId: roomId,
                x: full.waypoints.isNotEmpty ? full.waypoints.first.x : 200,
                y: full.waypoints.isNotEmpty ? full.waypoints.first.y : 200,
              ),
            ]
          : inRoom,
      speed: full.speed,
    );
  }
}
