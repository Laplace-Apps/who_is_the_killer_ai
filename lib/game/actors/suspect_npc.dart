import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../data/map_models.dart';
import '../data/sprite_catalog.dart';

class SuspectNpc extends SpriteAnimationGroupComponent<ActorAnim>
    with TapCallbacks {
  SuspectNpc({
    required this.suspectId,
    required this.displayName,
    required this.route,
    required Vector2 position,
    required Map<ActorAnim, SpriteAnimation> animations,
    required this.onTapped,
  }) : super(
          position: position,
          size: Vector2.all(SpriteCatalog.displaySize),
          anchor: Anchor.center,
          animations: animations,
          current: ActorAnim.idleDown,
        );

  final String suspectId;
  final String displayName;
  final NpcRoute route;
  final void Function(String suspectId) onTapped;

  int _waypointIndex = 0;
  double _idleTimer = 0;
  bool showNameplate = false;
  ActorAnim _lastIdle = ActorAnim.idleDown;
  Vector2 _velocity = Vector2.zero();

  @override
  void update(double dt) {
    super.update(dt);
    _velocity = Vector2.zero();

    if (route.waypoints.isEmpty) {
      _syncAnimation();
      return;
    }

    final target = route.waypoints[_waypointIndex % route.waypoints.length];
    final destination = Vector2(target.x, target.y);
    final delta = destination - position;
    if (delta.length < 6) {
      _idleTimer += dt;
      if (_idleTimer > 1.8) {
        _idleTimer = 0;
        _waypointIndex = (_waypointIndex + 1) % route.waypoints.length;
      }
      _syncAnimation();
      return;
    }
    _velocity = delta.normalized() * route.speed;
    position += _velocity * dt;
    _syncAnimation();
  }

  void _syncAnimation() {
    final next = animForMovement(
      velocity: _velocity,
      lastFacingIdle: _lastIdle,
    );
    _lastIdle = idleFor(next);
    if (current != next) {
      current = next;
    }
    scale.x = animFacesLeft(next) ? -1 : 1;
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTapped(suspectId);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (!showNameplate) return;

    final tp = TextPainter(
      text: TextSpan(
        text: displayName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 120);

    // Undo horizontal flip for readable nameplate.
    final flip = scale.x < 0;
    if (flip) {
      canvas.save();
      canvas.scale(-1, 1);
    }

    final bg = Paint()..color = const Color(0xAA0B121A);
    final centerX = flip ? 0.0 : 0.0;
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, -size.y / 2 - 12),
        width: tp.width + 10,
        height: tp.height + 6,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(rect, bg);
    tp.paint(
      canvas,
      Offset(centerX - tp.width / 2, -size.y / 2 - 12 - tp.height / 2),
    );
    if (flip) {
      canvas.restore();
    }
  }
}
