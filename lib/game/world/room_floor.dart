import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../data/map_models.dart';

class RoomFloor extends PositionComponent {
  RoomFloor({
    required this.room,
    this.floorTile,
  }) : super(
          size: Vector2(room.width, room.height),
          position: Vector2.zero(),
        );

  final MapRoom room;
  final Sprite? floorTile;

  Color _parse(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  void render(Canvas canvas) {
    final base = _parse(room.floorColor);
    canvas.drawRect(size.toRect(), Paint()..color = base);

    final tile = floorTile;
    if (tile != null) {
      const step = 32.0;
      final tint = Paint()
        ..colorFilter = ColorFilter.mode(
          _parse(room.accentColor).withValues(alpha: 0.22),
          BlendMode.srcATop,
        );
      for (var x = 0.0; x < size.x; x += step) {
        for (var y = 0.0; y < size.y; y += step) {
          canvas.save();
          canvas.translate(x, y);
          tile.render(
            canvas,
            size: Vector2(step, step),
            overridePaint: tint,
          );
          canvas.restore();
        }
      }
    } else {
      final accent =
          Paint()..color = _parse(room.accentColor).withValues(alpha: 0.18);
      for (var i = 40.0; i < size.x; i += 40) {
        canvas.drawLine(Offset(i, 0), Offset(i, size.y), accent);
      }
      for (var j = 40.0; j < size.y; j += 40) {
        canvas.drawLine(Offset(0, j), Offset(size.x, j), accent);
      }
    }

    final wallPaint = Paint()..color = const Color(0xFF0A1018);
    for (final wall in room.walls) {
      canvas.drawRect(
        Rect.fromLTWH(wall.x, wall.y, wall.w, wall.h),
        wallPaint,
      );
    }
  }
}

/// Non-interactive decorative prop for room depth.
class DecorProp extends SpriteComponent {
  DecorProp({
    required Sprite sprite,
    required Vector2 position,
    Vector2? size,
  }) : super(
          sprite: sprite,
          position: position,
          size: size ?? Vector2(32, 32),
          anchor: Anchor.center,
        );
}
