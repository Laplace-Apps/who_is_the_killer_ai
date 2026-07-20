import 'dart:async';

import 'package:who_is_the_killer_ai/models/character.dart';
import 'package:who_is_the_killer_ai/models/game_state.dart';
import 'package:who_is_the_killer_ai/services/ai_chat_service.dart';
import 'package:who_is_the_killer_ai/services/auth_service.dart';
import 'package:who_is_the_killer_ai/services/firebase_service.dart';
import 'package:who_is_the_killer_ai/services/game_persistence.dart';
import 'package:who_is_the_killer_ai/services/onboarding_preferences.dart';

class FakeAuthService implements AuthService {
  FakeAuthService({
    bool authenticated = false,
    this.authenticationError,
    this.socialAuthenticationError,
    this.googleAvailable = false,
    this.appleAvailable = false,
    this.socialResult = AuthFlowResult.success,
  }) : _isAuthenticated = authenticated;

  final Object? authenticationError;
  final Object? socialAuthenticationError;
  final bool googleAvailable;
  final bool appleAvailable;
  final AuthFlowResult socialResult;
  final _controller = StreamController<bool>.broadcast();

  bool _isAuthenticated;
  int signInCalls = 0;
  int signUpCalls = 0;
  int resetPasswordCalls = 0;
  int googleSignInCalls = 0;
  int appleSignInCalls = 0;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  bool get isGoogleSignInAvailable => googleAvailable;

  @override
  bool get isAppleSignInAvailable => appleAvailable;

  @override
  Stream<bool> get authenticationChanges => _controller.stream;

  @override
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    signUpCalls++;
    _completeAuthentication();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    resetPasswordCalls++;
    final error = authenticationError;
    if (error != null) throw error;
  }

  @override
  Future<AuthFlowResult> signInWithGoogle() async {
    googleSignInCalls++;
    return _completeSocialAuthentication();
  }

  @override
  Future<AuthFlowResult> signInWithApple() async {
    appleSignInCalls++;
    return _completeSocialAuthentication();
  }

  AuthFlowResult _completeSocialAuthentication() {
    final error = socialAuthenticationError;
    if (error != null) throw error;
    if (socialResult == AuthFlowResult.success) {
      _isAuthenticated = true;
      _controller.add(true);
    }
    return socialResult;
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    _completeAuthentication();
  }

  void _completeAuthentication() {
    final error = authenticationError;
    if (error != null) {
      throw error;
    }
    _isAuthenticated = true;
    _controller.add(true);
  }

  @override
  Future<void> signOut() async {
    _isAuthenticated = false;
    _controller.add(false);
  }

  Future<void> dispose() => _controller.close();
}

class MemoryOnboardingPreferences implements OnboardingPreferences {
  MemoryOnboardingPreferences({this.completed = true});

  bool completed;
  int readCalls = 0;
  int completeCalls = 0;

  @override
  Future<bool> isCompleted() async {
    readCalls++;
    return completed;
  }

  @override
  Future<void> markCompleted() async {
    completeCalls++;
    completed = true;
  }
}

class FakeCharacterChatService implements CharacterChatService {
  FakeCharacterChatService({this.response = 'Mock suspect response'});

  final String response;
  int calls = 0;

  @override
  Future<String> getCharacterResponse(
    Character character,
    String userMessage,
    String gameContext,
    String languageCode,
  ) async {
    calls++;
    return response;
  }
}

class MemoryGamePersistence implements GamePersistence {
  MemoryGamePersistence({this.savedGameState});

  GameState? savedGameState;
  int saveCalls = 0;
  int loadCalls = 0;
  int clearCalls = 0;
  int statsCalls = 0;

  @override
  Future<void> saveGameState(GameState gameState) async {
    saveCalls++;
    savedGameState = gameState;
  }

  @override
  Future<GameState?> loadGameState() async {
    loadCalls++;
    return savedGameState;
  }

  @override
  Future<void> clearGameState() async {
    clearCalls++;
    savedGameState = null;
  }

  @override
  Future<void> saveGameStats({
    required bool isCorrect,
    required String selectedCharacter,
    required String realKiller,
    required int conversationCount,
    required Duration gameDuration,
  }) async {
    statsCalls++;
  }

  @override
  Future<Map<String, dynamic>> getUserStats() async => {};
}

class FakeFirebaseService implements FirebaseService {
  GameState? remoteGameState;
  int deleteCalls = 0;

  @override
  Future<void> saveGameState(GameState gameState) async {
    remoteGameState = gameState;
  }

  @override
  Future<GameState?> loadGameState() async => remoteGameState;

  @override
  Future<void> deleteGameState() async {
    deleteCalls++;
    remoteGameState = null;
  }

  @override
  Future<void> saveGameStats({
    required bool isCorrect,
    required String selectedCharacter,
    required String realKiller,
    required int conversationCount,
    required Duration gameDuration,
  }) async {}

  @override
  Future<Map<String, dynamic>> getUserStats() async => {};
}
