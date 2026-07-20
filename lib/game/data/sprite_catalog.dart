import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';

/// Facing + locomotion states for top-down actors.
enum ActorAnim {
  idleDown,
  walkDown,
  idleRight,
  walkRight,
  idleLeft,
  walkLeft,
  idleUp,
  walkUp,
}

enum CharacterSheetId {
  detective,
  suspectA,
  suspectB,
}

enum CluePropKind {
  chest,
  barrel,
  lamp,
}

/// Asset paths and sheet layout for investigation sprites.
class SpriteCatalog {
  SpriteCatalog._();

  static const frameSize = 32.0;
  static const displaySize = 48.0;

  static const characterPaths = <CharacterSheetId, String>{
    CharacterSheetId.detective: 'characters/detective.png',
    CharacterSheetId.suspectA: 'characters/suspect_a.png',
    CharacterSheetId.suspectB: 'characters/suspect_b.png',
  };

  static const propsPath = 'tiles/props.png';

  /// Cycle three sheets across six suspects.
  static CharacterSheetId sheetForSuspect(String suspectId) {
    switch (suspectId) {
      case 'suspect_01':
      case 'suspect_04':
        return CharacterSheetId.suspectA;
      case 'suspect_02':
      case 'suspect_05':
        return CharacterSheetId.suspectB;
      case 'suspect_03':
      case 'suspect_06':
      default:
        return CharacterSheetId.detective;
    }
  }

  static CluePropKind propKindFromName(String? name) {
    switch (name) {
      case 'barrel':
        return CluePropKind.barrel;
      case 'lamp':
        return CluePropKind.lamp;
      case 'chest':
      default:
        return CluePropKind.chest;
    }
  }

  /// Source rects inside [propsPath] (192x288 atlas).
  static Rect propSrc(CluePropKind kind) {
    switch (kind) {
      case CluePropKind.chest:
        return const Rect.fromLTWH(48, 241, 32, 32);
      case CluePropKind.barrel:
        return const Rect.fromLTWH(65, 224, 14, 16);
      case CluePropKind.lamp:
        return const Rect.fromLTWH(32, 227, 16, 45);
    }
  }
}

/// Builds idle/walk animation groups from 32px character sheets.
///
/// Layout (row = animation, cols = frames):
/// 0 idleDown(2), 1 walkDown(6), 2 idleRight(2), 3 walkRight(6),
/// 4 idleUp(2), 5 walkUp(6). Left reuses right frames; actors flip with scale.x.
class CharacterSpriteLoader {
  CharacterSpriteLoader(this._images);

  final Images _images;

  Future<Map<ActorAnim, SpriteAnimation>> load(CharacterSheetId id) async {
    final path = SpriteCatalog.characterPaths[id]!;
    final image = await _images.load(path);
    final sheet = SpriteSheet(
      image: image,
      srcSize: Vector2.all(SpriteCatalog.frameSize),
    );

    // Flame SpriteSheet.createAnimation: [from, to) exclusive end.
    final idleDown = sheet.createAnimation(
      row: 0,
      from: 0,
      to: 2,
      stepTime: 0.35,
    );
    final walkDown = sheet.createAnimation(
      row: 1,
      from: 0,
      to: 6,
      stepTime: 0.1,
    );
    final idleRight = sheet.createAnimation(
      row: 2,
      from: 0,
      to: 2,
      stepTime: 0.35,
    );
    final walkRight = sheet.createAnimation(
      row: 3,
      from: 0,
      to: 6,
      stepTime: 0.1,
    );
    final idleUp = sheet.createAnimation(
      row: 4,
      from: 0,
      to: 2,
      stepTime: 0.35,
    );
    final walkUp = sheet.createAnimation(
      row: 5,
      from: 0,
      to: 6,
      stepTime: 0.1,
    );

    return {
      ActorAnim.idleDown: idleDown,
      ActorAnim.walkDown: walkDown,
      ActorAnim.idleRight: idleRight,
      ActorAnim.walkRight: walkRight,
      ActorAnim.idleLeft: idleRight,
      ActorAnim.walkLeft: walkRight,
      ActorAnim.idleUp: idleUp,
      ActorAnim.walkUp: walkUp,
    };
  }

  Future<Sprite> loadProp(CluePropKind kind) async {
    final image = await _images.load(SpriteCatalog.propsPath);
    final rect = SpriteCatalog.propSrc(kind);
    return Sprite(
      image,
      srcPosition: Vector2(rect.left, rect.top),
      srcSize: Vector2(rect.width, rect.height),
    );
  }

  /// Small dirt tile from the atlas for tinted floor texture.
  Future<Sprite> loadFloorTile() async {
    final image = await _images.load(SpriteCatalog.propsPath);
    return Sprite(
      image,
      srcPosition: Vector2(16, 64),
      srcSize: Vector2(16, 16),
    );
  }
}

ActorAnim animForMovement({
  required Vector2 velocity,
  required ActorAnim lastFacingIdle,
}) {
  if (velocity.length2 < 4) {
    return lastFacingIdle;
  }
  final absX = velocity.x.abs();
  final absY = velocity.y.abs();
  if (absX >= absY) {
    return velocity.x >= 0 ? ActorAnim.walkRight : ActorAnim.walkLeft;
  }
  return velocity.y >= 0 ? ActorAnim.walkDown : ActorAnim.walkUp;
}

ActorAnim idleFor(ActorAnim anim) {
  switch (anim) {
    case ActorAnim.walkDown:
    case ActorAnim.idleDown:
      return ActorAnim.idleDown;
    case ActorAnim.walkRight:
    case ActorAnim.idleRight:
      return ActorAnim.idleRight;
    case ActorAnim.walkLeft:
    case ActorAnim.idleLeft:
      return ActorAnim.idleLeft;
    case ActorAnim.walkUp:
    case ActorAnim.idleUp:
      return ActorAnim.idleUp;
  }
}

bool animFacesLeft(ActorAnim anim) =>
    anim == ActorAnim.idleLeft || anim == ActorAnim.walkLeft;
