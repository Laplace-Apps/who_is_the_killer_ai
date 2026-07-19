import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_the_killer_ai/data/game_data.dart';
import 'package:who_is_the_killer_ai/providers/game_provider.dart';
import 'package:who_is_the_killer_ai/providers/language_provider.dart';
import 'package:who_is_the_killer_ai/services/ai_chat_service.dart';

import '../support/fakes.dart';

void main() {
  group('GameProvider', () {
    test('starts a game with three suspects and persists it', () async {
      final persistence = MemoryGamePersistence();
      final provider = GameProvider(gamePersistence: persistence);

      await provider.startNewGame(LanguageProvider());

      expect(provider.gameState?.characters, hasLength(3));
      expect(provider.currentCharacter, isNull);
      expect(provider.currentConversation, isEmpty);
      expect(persistence.saveCalls, 1);
    });

    test('selects a suspect, records a mock reply, and persists', () async {
      final persistence = MemoryGamePersistence();
      final chatService = FakeCharacterChatService(response: 'Test response');
      final provider = GameProvider(
        chatService: chatService,
        gamePersistence: persistence,
      );
      final languageProvider = LanguageProvider();
      await provider.startNewGame(languageProvider);
      final suspect = provider.gameState!.characters.first;

      provider.selectCharacter(suspect);
      await provider.chatWithCharacter('Neredeydin?', languageProvider);

      expect(provider.currentCharacter, suspect);
      expect(provider.currentConversation, hasLength(2));
      expect(provider.currentConversation.last, contains('Test response'));
      expect(chatService.calls, 1);
      expect(persistence.saveCalls, 2);
    });

    test('restores saved progress and conversations', () async {
      final savedState = GameData.createNewGame()
          .updateConversationForCharacter('Prof. Dr. Ahmet Yılmaz', const [
            'Dedektif: Merhaba',
          ]);
      final persistence = MemoryGamePersistence(savedGameState: savedState);
      final provider = GameProvider(gamePersistence: persistence);

      await provider.loadGameState();

      expect(provider.gameState?.storyTitle, savedState.storyTitle);
      expect(
        provider.gameState?.characterConversations,
        savedState.characterConversations,
      );
      expect(persistence.loadCalls, 1);
    });
  });

  test('local mock returns a deterministic response', () async {
    const chatService = LocalMockCharacterChatService();
    final character = GameData.createNewGame().characters.first;

    final first = await chatService.getCharacterResponse(
      character,
      'Neredeydin?',
      'context',
      'tr',
    );
    final second = await chatService.getCharacterResponse(
      character,
      'Neredeydin?',
      'context',
      'tr',
    );

    expect(second, first);
  });
}
