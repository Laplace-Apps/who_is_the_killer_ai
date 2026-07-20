import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../data/map_models.dart';
import '../data/sprite_catalog.dart';

class ClueHotspot extends SpriteComponent with TapCallbacks {
  ClueHotspot({
    required this.spot,
    required this.discovered,
    required this.onCollect,
    required Sprite propSprite,
  }) : super(
          sprite: propSprite,
          position: Vector2(spot.x, spot.y),
          size: _sizeFor(SpriteCatalog.propKindFromName(spot.prop)),
          anchor: Anchor.center,
        );

  final MapClueSpot spot;
  bool discovered;
  final void Function(String clueId) onCollect;

  static Vector2 _sizeFor(CluePropKind kind) {
    switch (kind) {
      case CluePropKind.chest:
        return Vector2(36, 36);
      case CluePropKind.barrel:
        return Vector2(28, 32);
      case CluePropKind.lamp:
        return Vector2(24, 48);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!discovered) {
      onCollect(spot.id);
    }
  }

  @override
  void render(Canvas canvas) {
    if (discovered) {
      canvas.saveLayer(size.toRect(), Paint());
      super.render(canvas);
      canvas.drawRect(
        size.toRect(),
        Paint()
          ..color = const Color(0x883A5A3A)
          ..blendMode = BlendMode.srcATop,
      );
      canvas.restore();
    } else {
      super.render(canvas);
      final glow = Paint()
        ..color = const Color(0x44FFD700)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(-2, -2, size.x + 4, size.y + 4),
          const Radius.circular(4),
        ),
        glow,
      );
    }
  }
}

class PortalMarker extends PositionComponent {
  PortalMarker({required this.portal})
      : super(
          position: Vector2(
            portal.bounds.x + portal.bounds.w / 2,
            portal.bounds.y + portal.bounds.h / 2,
          ),
          size: Vector2(portal.bounds.w, portal.bounds.h),
          anchor: Anchor.center,
        );

  final MapPortal portal;

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0x664A90A4);
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
      paint,
    );
  }
}
