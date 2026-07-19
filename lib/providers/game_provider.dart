import 'package:flutter/foundation.dart';

import '../data/game_data.dart';
import '../models/character.dart';
import '../models/game_state.dart';
import '../providers/language_provider.dart';
import '../services/ai_chat_service.dart';
import '../services/game_persistence.dart';

class GameProvider with ChangeNotifier {
  factory GameProvider({
    CharacterChatService chatService = const LocalMockCharacterChatService(),
    GamePersistence? gamePersistence,
  }) {
    return GameProvider._(
      chatService,
      gamePersistence ?? FirebaseGamePersistence(),
    );
  }

  GameProvider._(this._chatService, this._gamePersistence);

  final CharacterChatService _chatService;
  final GamePersistence _gamePersistence;

  GameState? _gameState;
  Character? _currentCharacter;
  List<String> _currentConversation = [];
  bool _isLoading = false;
  DateTime? _gameStartTime;

  GameState? get gameState => _gameState;
  Character? get currentCharacter => _currentCharacter;
  List<String> get currentConversation => _currentConversation;
  bool get isLoading => _isLoading;

  // Oyunu başlat
  Future<void> startNewGame(LanguageProvider languageProvider) async {
    _gameState = GameData.createNewGame(languageProvider.currentLanguage);
    _currentCharacter = null;
    _currentConversation = [];
    _gameStartTime = DateTime.now();
    await _saveGameState();
    notifyListeners();
  }

  // Karakter seç
  void selectCharacter(Character character) {
    _currentCharacter = character;
    // Seçilen karakterin konuşma geçmişini yükle
    if (_gameState != null) {
      _currentConversation = _gameState!.getConversationForCharacter(
        character.name,
      );
    }
    notifyListeners();
  }

  // Karakterle konuş
  Future<void> chatWithCharacter(
    String message,
    LanguageProvider languageProvider,
  ) async {
    if (_currentCharacter == null || _gameState == null) return;

    _isLoading = true;
    notifyListeners();

    // Kullanıcı mesajını ekle
    _currentConversation.add('${languageProvider.t('detective')}: $message');

    try {
      // AI yanıtını al
      final response = await _chatService.getCharacterResponse(
        _currentCharacter!,
        message,
        _gameState!.storyDescription,
        languageProvider.currentLanguage.code,
      );

      // AI yanıtını ekle
      _currentConversation.add('${_currentCharacter!.name}: $response');

      // Bu karakterin konuşma geçmişini güncelle
      _gameState = _gameState!.updateConversationForCharacter(
        _currentCharacter!.name,
        _currentConversation,
      );

      await _saveGameState();
    } catch (e) {
      _currentConversation.add(
        '${_currentCharacter!.name}: ${languageProvider.t('sorry_cannot_answer')}',
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  // Son kararı ver
  Future<void> makeFinalDecision(Character selectedCharacter) async {
    if (_gameState == null) return;

    _gameState = _gameState!.copyWith(
      selectedKiller: selectedCharacter,
      gameCompleted: true,
    );

    await _saveGameState();

    // Oyun istatistiklerini kaydet
    if (_gameStartTime != null) {
      final gameDuration = DateTime.now().difference(_gameStartTime!);
      final realKiller = getRealKiller();
      final totalConversations = _gameState!.characterConversations.values
          .map((conv) => conv.length)
          .fold(0, (sum, length) => sum + length);

      await _gamePersistence.saveGameStats(
        isCorrect: isCorrectGuess(),
        selectedCharacter: selectedCharacter.name,
        realKiller: realKiller?.name ?? 'Bilinmiyor',
        conversationCount: totalConversations,
        gameDuration: gameDuration,
      );
    }

    notifyListeners();
  }

  // Oyunu kaydet
  Future<void> _saveGameState() async {
    if (_gameState == null) return;

    try {
      await _gamePersistence.saveGameState(_gameState!);
    } catch (e) {
      print('Oyun kaydedilemedi: $e');
    }
  }

  // Oyunu yükle
  Future<void> loadGameState() async {
    try {
      final savedGameState = await _gamePersistence.loadGameState();
      if (savedGameState != null) {
        _gameState = savedGameState;
      }

      // Eğer mevcut bir karakter seçiliyse, onun konuşma geçmişini yükle
      if (_gameState != null && _currentCharacter != null) {
        _currentConversation = _gameState!.getConversationForCharacter(
          _currentCharacter!.name,
        );
      }

      notifyListeners();
    } catch (e) {
      print('Oyun yüklenemedi: $e');
    }
  }

  // Oyunu sıfırla
  Future<void> resetGame() async {
    try {
      await _gamePersistence.clearGameState();
      _gameState = null;
      _currentCharacter = null;
      _currentConversation = [];
      notifyListeners();
    } catch (e) {
      print('Oyun sıfırlanamadı: $e');
    }
  }

  // Oyun sonucunu kontrol et (sadece geliştirici için)
  bool isCorrectGuess() {
    if (_gameState?.selectedKiller == null) return false;
    return _gameState!.selectedKiller!.isKiller;
  }

  // Gerçek katili al (sadece geliştirici için)
  Character? getRealKiller() {
    if (_gameState == null) return null;
    try {
      return _gameState!.characters.firstWhere((c) => c.isKiller);
    } catch (e) {
      return null;
    }
  }

  // Kullanıcı istatistiklerini al
  Future<Map<String, dynamic>> getUserStats() =>
      _gamePersistence.getUserStats();
}
