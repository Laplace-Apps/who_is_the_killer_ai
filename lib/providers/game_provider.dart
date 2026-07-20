import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import '../models/character.dart';
import '../models/game_state.dart';
import '../providers/language_provider.dart';
import '../services/accusation_service.dart';
import '../services/ai_chat_service.dart';
import '../services/case_content_repository.dart';
import '../services/game_persistence.dart';
import '../game/investigation_event.dart';

class GameProvider with ChangeNotifier {
  factory GameProvider({
    CharacterChatService chatService = const LocalMockCharacterChatService(),
    GamePersistence? gamePersistence,
    CaseContentRepository? caseRepository,
    AccusationService? accusationService,
  }) {
    return GameProvider._(
      chatService,
      gamePersistence ?? FirebaseGamePersistence(),
      caseRepository ?? CaseContentRepository(),
      accusationService ?? const LocalMockAccusationService(),
    );
  }

  GameProvider._(
    this._chatService,
    this._gamePersistence,
    this._caseRepository,
    this._accusationService,
  );

  final CharacterChatService _chatService;
  final GamePersistence _gamePersistence;
  final CaseContentRepository _caseRepository;
  final AccusationService _accusationService;

  GameState? _gameState;
  CasePublicContent? _caseContent;
  Character? _currentCharacter;
  List<String> _currentConversation = [];
  bool _isLoading = false;
  DateTime? _gameStartTime;
  AccusationResult? _lastAccusationResult;
  String? _pendingSuspectId;
  String? _lastDiscoveredClueId;
  bool _notifyScheduled = false;

  GameState? get gameState => _gameState;
  CasePublicContent? get caseContent => _caseContent;
  Character? get currentCharacter => _currentCharacter;
  List<String> get currentConversation => _currentConversation;
  bool get isLoading => _isLoading;
  AccusationResult? get lastAccusationResult => _lastAccusationResult;
  String? get pendingSuspectId => _pendingSuspectId;
  String? get lastDiscoveredClueId => _lastDiscoveredClueId;

  /// Avoids "setState/markNeedsBuild during build" when Flame emits during a frame.
  void _notifySafely() {
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.idle ||
        phase == SchedulerPhase.postFrameCallbacks) {
      notifyListeners();
      return;
    }
    if (_notifyScheduled) return;
    _notifyScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _notifyScheduled = false;
      notifyListeners();
    });
  }

  Future<void> startNewGame(LanguageProvider languageProvider) async {
    _caseContent = await _caseRepository.loadPublicCase();
    _gameState = _caseContent!.toGameState(languageProvider.currentLanguage);
    _currentCharacter = null;
    _currentConversation = [];
    _lastAccusationResult = null;
    _pendingSuspectId = null;
    _lastDiscoveredClueId = null;
    _gameStartTime = DateTime.now();
    await _saveGameState();
    notifyListeners();
  }

  void selectCharacter(Character character) {
    _currentCharacter = character;
    if (_gameState != null) {
      _currentConversation = _gameState!.getConversationForCharacter(
        character.name,
      );
    }
    _notifySafely();
  }

  void selectCharacterById(String suspectId) {
    if (_gameState == null) return;
    for (final character in _gameState!.characters) {
      if (character.id == suspectId) {
        selectCharacter(character);
        return;
      }
    }
  }

  void clearPendingSuspect() {
    _pendingSuspectId = null;
    notifyListeners();
  }

  void clearLastDiscoveredClue() {
    _lastDiscoveredClueId = null;
    notifyListeners();
  }

  void handleInvestigationEvent(InvestigationEvent event) {
    if (_gameState == null) return;

    switch (event.type) {
      case InvestigationEventType.tapSuspect:
        _pendingSuspectId = event.suspectId;
        if (event.suspectId != null) {
          // selectCharacter already notifies.
          selectCharacterById(event.suspectId!);
        }
        return;
      case InvestigationEventType.discoverClue:
        if (event.clueId != null) {
          // discoverClue already notifies.
          discoverClue(event.clueId!);
        }
        return;
      case InvestigationEventType.enterRoom:
        if (event.roomId != null) {
          _gameState = _gameState!.copyWith(currentRoomId: event.roomId);
          _saveGameState();
        }
        break;
      case InvestigationEventType.proximity:
        final next = event.prompt;
        if (_gameState!.proximityPrompt == next) return;
        _gameState = _gameState!.copyWith(
          proximityPrompt: next,
          clearProximityPrompt: next == null,
        );
        break;
      case InvestigationEventType.playerMoved:
        // Persist coords without rebuilding Flutter UI every tick.
        if (event.x != null && event.y != null) {
          _gameState = _gameState!.copyWith(
            playerX: event.x,
            playerY: event.y,
          );
        }
        return;
    }
    _notifySafely();
  }

  Future<void> discoverClue(String clueId) async {
    if (_gameState == null) return;
    if (_gameState!.discoveredClueIds.contains(clueId)) return;

    final discovered = [..._gameState!.discoveredClueIds, clueId];
    var unlocked = List<String>.from(_gameState!.unlockedLocationIds);

    if (clueId == 'clue_07') {
      for (final room in ['location_01', 'location_06', 'location_07', 'location_08']) {
        if (!unlocked.contains(room)) unlocked.add(room);
      }
    }

    // Dome becomes available once investigation is underway.
    if (!unlocked.contains('location_01')) {
      unlocked.add('location_01');
    }

    _gameState = _gameState!.copyWith(
      discoveredClueIds: discovered,
      unlockedLocationIds: unlocked,
    );
    _lastDiscoveredClueId = clueId;
    await _saveGameState();
    _notifySafely();
  }

  Future<void> chatWithCharacter(
    String message,
    LanguageProvider languageProvider,
  ) async {
    if (_currentCharacter == null || _gameState == null) return;

    _isLoading = true;
    notifyListeners();

    _currentConversation.add('${languageProvider.t('detective')}: $message');

    try {
      final response = await _chatService.getCharacterResponse(
        _currentCharacter!,
        message,
        _gameState!.storyDescription,
        languageProvider.currentLanguage.code,
      );

      _currentConversation.add('${_currentCharacter!.name}: $response');
      _gameState = _gameState!.updateConversationForCharacter(
        _currentCharacter!.name,
        _currentConversation,
      );
      await _saveGameState();
    } catch (_) {
      _currentConversation.add(
        '${_currentCharacter!.name}: ${languageProvider.t('sorry_cannot_answer')}',
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<AccusationResult> makeFinalDecision(Character selectedCharacter) async {
    if (_gameState == null) {
      return const AccusationResult(
        isCorrect: false,
        hasRequiredEvidence: false,
        messageEn: 'No active game.',
        messageTr: 'Aktif oyun yok.',
      );
    }

    final result = await _accusationService.validate(
      accusedSuspectId: selectedCharacter.id,
      gameState: _gameState!,
    );
    _lastAccusationResult = result;

    if (!result.hasRequiredEvidence) {
      notifyListeners();
      return result;
    }

    _gameState = _gameState!.copyWith(
      selectedKiller: selectedCharacter,
      gameCompleted: true,
    );
    await _saveGameState();

    if (_gameStartTime != null) {
      final gameDuration = DateTime.now().difference(_gameStartTime!);
      final totalConversations = _gameState!.characterConversations.values
          .map((conv) => conv.length)
          .fold(0, (sum, length) => sum + length);

      await _gamePersistence.saveGameStats(
        isCorrect: result.isCorrect,
        selectedCharacter: selectedCharacter.name,
        realKiller: result.isCorrect
            ? selectedCharacter.name
            : 'classified',
        conversationCount: totalConversations,
        gameDuration: gameDuration,
      );
    }

    notifyListeners();
    return result;
  }

  Future<void> _saveGameState() async {
    if (_gameState == null) return;
    try {
      await _gamePersistence.saveGameState(_gameState!);
    } catch (e) {
      debugPrint('Oyun kaydedilemedi: $e');
    }
  }

  Future<void> loadGameState() async {
    try {
      final savedGameState = await _gamePersistence.loadGameState();
      if (savedGameState != null) {
        _gameState = savedGameState;
      }
      if (_gameState != null && _currentCharacter != null) {
        _currentConversation = _gameState!.getConversationForCharacter(
          _currentCharacter!.name,
        );
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Oyun yüklenemedi: $e');
    }
  }

  Future<void> ensureCaseContent() async {
    _caseContent ??= await _caseRepository.loadPublicCase();
    notifyListeners();
  }

  Future<void> resetGame() async {
    try {
      await _gamePersistence.clearGameState();
      _gameState = null;
      _currentCharacter = null;
      _currentConversation = [];
      _lastAccusationResult = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Oyun sıfırlanamadı: $e');
    }
  }

  bool isCorrectGuess() => _lastAccusationResult?.isCorrect ?? false;

  Character? getRealKiller() {
    // Client must not expose killer identity from character flags.
    return null;
  }

  Future<Map<String, dynamic>> getUserStats() =>
      _gamePersistence.getUserStats();

  bool isRoomUnlocked(String roomId) {
    return _gameState?.unlockedLocationIds.contains(roomId) ?? false;
  }

  bool canEnterPortal({
    required bool requiresUnlock,
    List<String> requiredClueIds = const [],
    String? destinationRoomId,
  }) {
    if (_gameState == null) return false;
    if (destinationRoomId != null &&
        !_gameState!.unlockedLocationIds.contains(destinationRoomId) &&
        requiresUnlock) {
      return false;
    }
    if (!requiresUnlock) return true;
    return requiredClueIds.every(_gameState!.discoveredClueIds.contains);
  }
}
