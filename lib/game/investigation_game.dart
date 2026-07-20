import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/character.dart';
import '../models/language.dart';
import 'actors/detective_player.dart';
import 'actors/suspect_npc.dart';
import 'data/map_models.dart';
import 'data/sprite_catalog.dart';
import 'interactables/clue_hotspot.dart';
import 'investigation_event.dart';
import 'systems/npc_schedule.dart';
import 'systems/pathfinding.dart';
import 'world/room_floor.dart';

typedef InvestigationEventCallback = void Function(InvestigationEvent event);

class InvestigationGame extends FlameGame
    with HasKeyboardHandlerComponents, TapCallbacks {
  InvestigationGame({
    required this.onEvent,
    required this.characters,
    required List<String> unlockedLocationIds,
    required List<String> discoveredClueIds,
    required this.isPortalAllowed,
    required this.language,
    this.initialRoomId = 'location_03',
    this.initialPlayerX = 400,
    this.initialPlayerY = 320,
  })  : unlockedLocationIds = List<String>.from(unlockedLocationIds),
        discoveredClueIds = List<String>.from(discoveredClueIds);

  final InvestigationEventCallback onEvent;
  final List<Character> characters;
  final List<String> unlockedLocationIds;
  final List<String> discoveredClueIds;
  final bool Function({
    required bool requiresUnlock,
    List<String> requiredClueIds,
    String? destinationRoomId,
  }) isPortalAllowed;
  final Language language;

  String initialRoomId;
  double initialPlayerX;
  double initialPlayerY;

  ObservatoryMapLayout? _layout;
  NpcRoutesData? _routes;
  NpcSchedule? _schedule;
  CharacterSpriteLoader? _sprites;
  final Map<CharacterSheetId, Map<ActorAnim, SpriteAnimation>> _animCache = {};
  final Map<CluePropKind, Sprite> _propCache = {};
  Sprite? _floorTile;
  Sprite? _decorBarrel;
  late DetectivePlayer _player;
  final List<SuspectNpc> _npcs = [];
  final List<ClueHotspot> _hotspots = [];
  MapRoom? _currentRoom;
  String _currentRoomId = 'location_03';
  Vector2 _joystick = Vector2.zero();
  double _portalCooldown = 0;
  double _moveEmitTimer = 0;
  String? _lastPrompt;

  String get currentRoomId => _currentRoomId;
  MapRoom? get currentRoom => _currentRoom;

  @override
  Color backgroundColor() => const Color(0xFF0B121A);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _layout = await ObservatoryMapLayout.load();
    _routes = await NpcRoutesData.load();
    _schedule = NpcSchedule(routes: _routes!.routes);

    _sprites = CharacterSpriteLoader(images);
    for (final id in CharacterSheetId.values) {
      _animCache[id] = await _sprites!.load(id);
    }
    for (final kind in CluePropKind.values) {
      _propCache[kind] = await _sprites!.loadProp(kind);
    }
    _floorTile = await _sprites!.loadFloorTile();
    _decorBarrel = _propCache[CluePropKind.barrel];

    camera.viewfinder.anchor = Anchor.center;

    _currentRoomId = initialRoomId;
    await _loadRoom(
      _currentRoomId,
      spawnOverride: Vector2(initialPlayerX, initialPlayerY),
    );
  }

  Map<ActorAnim, SpriteAnimation> _cloneAnims(CharacterSheetId id) {
    final source = _animCache[id]!;
    return {
      for (final entry in source.entries) entry.key: entry.value.clone(),
    };
  }

  Future<void> _loadRoom(String roomId, {Vector2? spawnOverride}) async {
    final layout = _layout!;
    final room = layout.rooms[roomId];
    if (room == null) return;

    world.removeAll(world.children.toList());
    _npcs.clear();
    _hotspots.clear();
    _currentRoom = room;
    _currentRoomId = roomId;

    await world.add(RoomFloor(room: room, floorTile: _floorTile));

    for (final portal in room.portals) {
      await world.add(PortalMarker(portal: portal));
    }

    // Decorative depth props (non-interactive).
    final barrel = _decorBarrel;
    if (barrel != null) {
      await world.add(
        DecorProp(
          sprite: barrel,
          position: Vector2(room.width * 0.18, room.height * 0.22),
          size: Vector2(28, 32),
        ),
      );
      await world.add(
        DecorProp(
          sprite: _propCache[CluePropKind.lamp]!,
          position: Vector2(room.width * 0.82, room.height * 0.28),
          size: Vector2(22, 44),
        ),
      );
    }

    for (final clue in room.clues) {
      final kind = SpriteCatalog.propKindFromName(clue.prop);
      final hotspot = ClueHotspot(
        spot: clue,
        discovered: discoveredClueIds.contains(clue.id),
        onCollect: (id) {
          onEvent(InvestigationEvent.discoverClue(id));
        },
        propSprite: _propCache[kind]!,
      );
      _hotspots.add(hotspot);
      await world.add(hotspot);
    }

    final spawn = spawnOverride ?? Vector2(room.spawn.x, room.spawn.y);
    _player = DetectivePlayer(
      position: spawn,
      animations: _cloneAnims(CharacterSheetId.detective),
    );
    await world.add(_player);
    camera.follow(_player);

    for (final character in characters) {
      final route = _schedule!.routeForRoom(
        suspectId: character.id,
        roomId: roomId,
        discoveredClueCount: discoveredClueIds.length,
      );
      if (route == null) continue;

      Vector2 npcPos = Vector2(room.spawn.x + 40, room.spawn.y + 40);
      if (route.waypoints.isNotEmpty) {
        npcPos = Vector2(route.waypoints.first.x, route.waypoints.first.y);
      }

      final sheetId = SpriteCatalog.sheetForSuspect(character.id);
      final npc = SuspectNpc(
        suspectId: character.id,
        displayName: character.name,
        route: route,
        position: npcPos,
        animations: _cloneAnims(sheetId),
        onTapped: (id) => onEvent(InvestigationEvent.tapSuspect(id)),
      );
      _npcs.add(npc);
      await world.add(npc);
    }

    onEvent(InvestigationEvent.enterRoom(roomId));
  }

  void setJoystick(Offset offset) {
    _joystick = Vector2(offset.dx, offset.dy);
  }

  void markClueDiscovered(String clueId) {
    for (final hotspot in _hotspots) {
      if (hotspot.spot.id == clueId) {
        hotspot.discovered = true;
      }
    }
  }

  void syncUnlocks(List<String> unlocked, List<String> discovered) {
    unlockedLocationIds
      ..clear()
      ..addAll(unlocked);
    discoveredClueIds
      ..clear()
      ..addAll(discovered);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (paused) return;
    final worldPos = camera.globalToLocal(event.canvasPosition);
    final hitNpc = _npcs.any((n) => n.containsPoint(worldPos));
    final hitClue = _hotspots.any((h) => h.containsPoint(worldPos));
    if (!hitNpc && !hitClue) {
      final room = _currentRoom;
      if (room == null) return;
      final pathfinder = GridPathfinder(
        roomWidth: room.width,
        roomHeight: room.height,
        walls: room.walls,
      );
      final path = pathfinder.findPath(_player.position, worldPos);
      if (path.isEmpty) {
        _player.moveTo(worldPos);
      } else {
        _player.followPath(path);
      }
    }
  }

  void setPaused(bool value) {
    if (value) {
      pauseEngine();
    } else {
      resumeEngine();
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    var x = 0.0;
    var y = 0.0;
    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      x -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      x += 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      y -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      y += 1;
    }
    _joystick = Vector2(x, y);
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final room = _currentRoom;
    if (room == null) return;

    _portalCooldown = (_portalCooldown - dt).clamp(0, 2);
    _player.setJoystick(_joystick);
    _player.tryMove(dt, room.walls, room.width, room.height);

    _moveEmitTimer += dt;
    if (_moveEmitTimer > 0.35) {
      _moveEmitTimer = 0;
      onEvent(
        InvestigationEvent.playerMoved(_player.position.x, _player.position.y),
      );
    }

    _updateProximity();
    _checkPortals();
  }

  void _updateProximity() {
    String? prompt;
    for (final npc in _npcs) {
      final near = (_player.position - npc.position).length < 56;
      npc.showNameplate = near;
      if (near && prompt == null) {
        String? name;
        for (final c in characters) {
          if (c.id == npc.suspectId) {
            name = c.name;
            break;
          }
        }
        prompt = language == Language.turkish
            ? '${name ?? npc.displayName} ile konuş'
            : 'Talk to ${name ?? npc.displayName}';
      }
    }
    if (prompt == null) {
      for (final hotspot in _hotspots) {
        if (!hotspot.discovered &&
            (_player.position - hotspot.position).length < 48) {
          prompt = language == Language.turkish
              ? hotspot.spot.labelTr
              : hotspot.spot.labelEn;
          break;
        }
      }
    }
    if (prompt != _lastPrompt) {
      _lastPrompt = prompt;
      onEvent(InvestigationEvent.proximity(prompt));
    }
  }

  void _checkPortals() {
    if (_portalCooldown > 0 || _currentRoom == null) return;
    final playerRect = MapRect(
      x: _player.position.x - 14,
      y: _player.position.y - 14,
      w: 28,
      h: 28,
    );

    for (final portal in _currentRoom!.portals) {
      if (!playerRect.overlaps(portal.bounds)) continue;
      final allowed = isPortalAllowed(
        requiresUnlock: portal.requiresUnlock,
        requiredClueIds: portal.requiredClueIds,
        destinationRoomId: portal.to,
      );
      if (!allowed) {
        final blocked = language == Language.turkish
            ? 'Bu alan kilitli — daha fazla kanıt lazım'
            : 'Area locked — need more evidence';
        if (_lastPrompt != blocked) {
          _lastPrompt = blocked;
          onEvent(InvestigationEvent.proximity(blocked));
        }
        continue;
      }
      _portalCooldown = 0.8;
      unawaited(_loadRoom(portal.to));
      break;
    }
  }

  void tryTalkNearest() {
    SuspectNpc? nearest;
    var best = 9999.0;
    for (final npc in _npcs) {
      final d = (_player.position - npc.position).length;
      if (d < best) {
        best = d;
        nearest = npc;
      }
    }
    if (nearest != null && best < 64) {
      onEvent(InvestigationEvent.tapSuspect(nearest.suspectId));
    }
  }
}
