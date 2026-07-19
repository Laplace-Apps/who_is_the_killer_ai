import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_state.dart';
import 'firebase_service.dart';

abstract interface class GamePersistence {
  Future<void> saveGameState(GameState gameState);

  Future<GameState?> loadGameState();

  Future<void> clearGameState();

  Future<void> saveGameStats({
    required bool isCorrect,
    required String selectedCharacter,
    required String realKiller,
    required int conversationCount,
    required Duration gameDuration,
  });

  Future<Map<String, dynamic>> getUserStats();
}

class FirebaseGamePersistence implements GamePersistence {
  FirebaseGamePersistence({
    FirebaseService? firebaseService,
    Future<SharedPreferences> Function()? preferencesFactory,
  }) : _firebaseService = firebaseService ?? FirebaseService(),
       _preferencesFactory =
           preferencesFactory ?? SharedPreferences.getInstance;

  static const _gameStateKey = 'gameState';

  final FirebaseService _firebaseService;
  final Future<SharedPreferences> Function() _preferencesFactory;

  @override
  Future<void> saveGameState(GameState gameState) async {
    final preferences = await _preferencesFactory();
    await preferences.setString(_gameStateKey, jsonEncode(gameState.toJson()));
    await _firebaseService.saveGameState(gameState);
  }

  @override
  Future<GameState?> loadGameState() async {
    final remoteGameState = await _firebaseService.loadGameState();
    if (remoteGameState != null) {
      return remoteGameState;
    }

    final preferences = await _preferencesFactory();
    final encodedGameState = preferences.getString(_gameStateKey);
    if (encodedGameState == null) {
      return null;
    }

    return GameState.fromJson(
      jsonDecode(encodedGameState) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> clearGameState() async {
    final preferences = await _preferencesFactory();
    await preferences.remove(_gameStateKey);
    await _firebaseService.deleteGameState();
  }

  @override
  Future<void> saveGameStats({
    required bool isCorrect,
    required String selectedCharacter,
    required String realKiller,
    required int conversationCount,
    required Duration gameDuration,
  }) {
    return _firebaseService.saveGameStats(
      isCorrect: isCorrect,
      selectedCharacter: selectedCharacter,
      realKiller: realKiller,
      conversationCount: conversationCount,
      gameDuration: gameDuration,
    );
  }

  @override
  Future<Map<String, dynamic>> getUserStats() =>
      _firebaseService.getUserStats();
}
