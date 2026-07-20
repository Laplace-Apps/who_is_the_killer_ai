import 'package:flame/components.dart';

import '../data/map_models.dart';
import '../data/sprite_catalog.dart';

class DetectivePlayer extends SpriteAnimationGroupComponent<ActorAnim> {
  DetectivePlayer({
    required Vector2 position,
    required Map<ActorAnim, SpriteAnimation> animations,
    this.moveSpeed = 140,
  }) : super(
          position: position,
          size: Vector2.all(SpriteCatalog.displaySize),
          anchor: Anchor.center,
          animations: animations,
          current: ActorAnim.idleDown,
        );

  final double moveSpeed;
  Vector2 velocity = Vector2.zero();
  Vector2? _target;
  final List<Vector2> _path = [];
  ActorAnim _lastIdle = ActorAnim.idleDown;

  void setJoystick(Vector2 direction) {
    if (direction.length2 < 0.01) {
      velocity = Vector2.zero();
      return;
    }
    _target = null;
    _path.clear();
    velocity = direction.normalized() * moveSpeed;
  }

  void moveTo(Vector2 worldPoint) {
    _path.clear();
    _target = worldPoint.clone();
  }

  void followPath(List<Vector2> waypoints) {
    _path
      ..clear()
      ..addAll(waypoints);
    _target = _path.isEmpty ? null : _path.removeAt(0);
  }

  void clearTarget() {
    _target = null;
    _path.clear();
    velocity = Vector2.zero();
  }

  bool tryMove(
    double dt,
    List<MapRect> walls,
    double roomWidth,
    double roomHeight,
  ) {
    if (_target != null) {
      final toTarget = _target! - position;
      if (toTarget.length < 4) {
        if (_path.isNotEmpty) {
          _target = _path.removeAt(0);
        } else {
          _target = null;
          velocity = Vector2.zero();
        }
      } else {
        velocity = toTarget.normalized() * moveSpeed;
      }
    }

    if (velocity.length2 < 0.01) {
      _syncAnimation();
      return false;
    }

    final next = position + velocity * dt;
    final half = size.x / 2;
    final clamped = Vector2(
      next.x.clamp(half + 4, roomWidth - half - 4),
      next.y.clamp(half + 4, roomHeight - half - 4),
    );

    final body = MapRect(
      x: clamped.x - half,
      y: clamped.y - half,
      w: size.x,
      h: size.y,
    );

    for (final wall in walls) {
      if (body.overlaps(wall)) {
        final tryX = Vector2(clamped.x, position.y);
        final bodyX = MapRect(
          x: tryX.x - half,
          y: tryX.y - half,
          w: size.x,
          h: size.y,
        );
        final tryY = Vector2(position.x, clamped.y);
        final bodyY = MapRect(
          x: tryY.x - half,
          y: tryY.y - half,
          w: size.x,
          h: size.y,
        );
        var blocked = true;
        if (!walls.any(bodyX.overlaps)) {
          position = tryX;
          blocked = false;
        } else if (!walls.any(bodyY.overlaps)) {
          position = tryY;
          blocked = false;
        }
        if (blocked) {
          velocity = Vector2.zero();
          _target = null;
          _path.clear();
        }
        _syncAnimation();
        return true;
      }
    }

    position = clamped;
    _syncAnimation();
    return true;
  }

  void _syncAnimation() {
    final next = animForMovement(
      velocity: velocity,
      lastFacingIdle: _lastIdle,
    );
    _lastIdle = idleFor(next);
    if (current != next) {
      current = next;
    }
    final faceLeft = animFacesLeft(next);
    scale.x = faceLeft ? -1 : 1;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _syncAnimation();
  }
}
