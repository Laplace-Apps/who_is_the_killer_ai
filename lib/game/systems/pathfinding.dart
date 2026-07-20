import 'dart:collection';
import 'dart:math' as math;

import 'package:flame/components.dart';

import '../data/map_models.dart';

/// Coarse grid A* for tap-to-move around wall rectangles.
class GridPathfinder {
  GridPathfinder({
    required this.roomWidth,
    required this.roomHeight,
    required this.walls,
    this.cellSize = 32,
  });

  final double roomWidth;
  final double roomHeight;
  final List<MapRect> walls;
  final double cellSize;

  late final int cols = math.max(1, (roomWidth / cellSize).floor());
  late final int rows = math.max(1, (roomHeight / cellSize).floor());

  bool _blocked(int cx, int cy) {
    if (cx < 0 || cy < 0 || cx >= cols || cy >= rows) return true;
    final rect = MapRect(
      x: cx * cellSize + 2,
      y: cy * cellSize + 2,
      w: cellSize - 4,
      h: cellSize - 4,
    );
    return walls.any(rect.overlaps);
  }

  (int, int) _cellOf(Vector2 point) {
    final cx = (point.x / cellSize).floor().clamp(0, cols - 1);
    final cy = (point.y / cellSize).floor().clamp(0, rows - 1);
    return (cx, cy);
  }

  Vector2 _centerOf(int cx, int cy) {
    return Vector2(cx * cellSize + cellSize / 2, cy * cellSize + cellSize / 2);
  }

  /// Returns waypoints from [start] to [goal], or empty if unreachable.
  List<Vector2> findPath(Vector2 start, Vector2 goal) {
    var (sx, sy) = _cellOf(start);
    var (gx, gy) = _cellOf(goal);
    if (_blocked(sx, sy)) {
      final open = _nearestOpen(sx, sy);
      if (open == null) return const [];
      sx = open.$1;
      sy = open.$2;
    }
    if (_blocked(gx, gy)) {
      final open = _nearestOpen(gx, gy);
      if (open == null) return const [];
      gx = open.$1;
      gy = open.$2;
    }

    final startKey = _key(sx, sy);
    final goalKey = _key(gx, gy);
    final cameFrom = <int, int>{};
    final gScore = <int, double>{startKey: 0};
    final openSet = SplayTreeSet<_Node>((a, b) {
      final c = a.f.compareTo(b.f);
      if (c != 0) return c;
      return a.key.compareTo(b.key);
    });
    openSet.add(_Node(startKey, _heuristic(sx, sy, gx, gy)));

    const dirs = [
      (1, 0),
      (-1, 0),
      (0, 1),
      (0, -1),
      (1, 1),
      (1, -1),
      (-1, 1),
      (-1, -1),
    ];

    while (openSet.isNotEmpty) {
      final current = openSet.first;
      openSet.remove(current);
      if (current.key == goalKey) {
        return _reconstruct(cameFrom, current.key, start, goal);
      }

      final cx = current.key % cols;
      final cy = current.key ~/ cols;
      for (final (dx, dy) in dirs) {
        final nx = cx + dx;
        final ny = cy + dy;
        if (_blocked(nx, ny)) continue;
        if (dx != 0 && dy != 0) {
          if (_blocked(cx + dx, cy) || _blocked(cx, cy + dy)) continue;
        }
        final neighbor = _key(nx, ny);
        final step = (dx != 0 && dy != 0) ? 1.414 : 1.0;
        final tentative = (gScore[current.key] ?? double.infinity) + step;
        if (tentative < (gScore[neighbor] ?? double.infinity)) {
          cameFrom[neighbor] = current.key;
          gScore[neighbor] = tentative;
          final f = tentative + _heuristic(nx, ny, gx, gy);
          openSet.removeWhere((n) => n.key == neighbor);
          openSet.add(_Node(neighbor, f));
        }
      }
    }
    return const [];
  }

  (int, int)? _nearestOpen(int cx, int cy) {
    for (var r = 0; r < 6; r++) {
      for (var dx = -r; dx <= r; dx++) {
        for (var dy = -r; dy <= r; dy++) {
          if (!_blocked(cx + dx, cy + dy)) return (cx + dx, cy + dy);
        }
      }
    }
    return null;
  }

  double _heuristic(int x, int y, int gx, int gy) {
    final dx = (x - gx).abs();
    final dy = (y - gy).abs();
    return dx + dy + (math.sqrt2 - 2) * math.min(dx, dy);
  }

  int _key(int x, int y) => y * cols + x;

  List<Vector2> _reconstruct(
    Map<int, int> cameFrom,
    int current,
    Vector2 start,
    Vector2 goal,
  ) {
    final cells = <int>[current];
    while (cameFrom.containsKey(current)) {
      current = cameFrom[current]!;
      cells.add(current);
    }
    final points = <Vector2>[start];
    for (final key in cells.reversed) {
      points.add(_centerOf(key % cols, key ~/ cols));
    }
    points.add(goal);
    return points;
  }
}

class _Node {
  const _Node(this.key, this.f);
  final int key;
  final double f;
}
