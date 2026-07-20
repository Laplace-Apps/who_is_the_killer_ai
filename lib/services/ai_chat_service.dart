import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/character.dart';

abstract interface class CharacterChatService {
  Future<String> getCharacterResponse(
    Character character,
    String userMessage,
    String gameContext,
    String languageCode,
  );
}

/// Non-production responder used until Firebase AI Logic Cloud Function is live.
class LocalMockCharacterChatService implements CharacterChatService {
  const LocalMockCharacterChatService();

  @override
  Future<String> getCharacterResponse(
    Character character,
    String userMessage,
    String gameContext,
    String languageCode,
  ) async {
    final message = userMessage.toLowerCase();
    final isTr = languageCode.startsWith('tr');

    if (message.contains('nerede') ||
        message.contains('where') ||
        message.contains('alibi')) {
      return isTr
          ? '${character.alibi} Daha fazla ayrıntıyı hatırlamıyorum.'
          : '${character.alibi} That is all I will say for now.';
    }
    if (message.contains('ilişki') ||
        message.contains('relationship') ||
        message.contains('alistair')) {
      return isTr
          ? 'Alistair ile bağlarım karmaşıktı. ${character.background}'
          : 'My connection to Alistair was complicated. ${character.background}';
    }
    if (message.contains('katil') ||
        message.contains('killer') ||
        message.contains('öldür') ||
        message.contains('murder')) {
      return isTr
          ? 'Beni suçlamak için kanıtınız yok. Ben ${character.role} olarak buradayım.'
          : 'You have no proof against me. I am here as ${character.role}.';
    }
    if (message.contains('anahtar') || message.contains('key')) {
      return isTr
          ? 'Ana anahtar Silas\'ın sorumluluğunda. Benim işim değil.'
          : 'The master key is Silas\'s responsibility, not mine.';
    }
    if (message.contains('hava') ||
        message.contains('weather') ||
        message.contains('whiteout')) {
      return isTr
          ? 'Fırtına her şeyi yuttu. Görüş neredeyse sıfırdı.'
          : 'The storm swallowed everything. Visibility was nearly zero.';
    }

    return isTr
        ? 'Bilmiyorum... ya da söylemek istemiyorum. (${character.personality})'
        : 'I don\'t know... or I don\'t want to say. (${character.personality})';
  }
}

/// Calls a Firebase Cloud Function that assembles server-side private prompts.
/// Private files (killer_private, solution_private, character_*_private) never
/// leave the server. Falls back to [LocalMockCharacterChatService] when
/// [functionUrl] is unset.
class FirebaseAiCharacterChatService implements CharacterChatService {
  FirebaseAiCharacterChatService({
    this.functionUrl,
    this._fallback = const LocalMockCharacterChatService(),
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final String? functionUrl;
  final CharacterChatService _fallback;
  final http.Client _http;

  @override
  Future<String> getCharacterResponse(
    Character character,
    String userMessage,
    String gameContext,
    String languageCode,
  ) async {
    final url = functionUrl;
    if (url == null || url.isEmpty) {
      return _fallback.getCharacterResponse(
        character,
        userMessage,
        gameContext,
        languageCode,
      );
    }

    try {
      final response = await _http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'suspectId': character.id,
          'message': userMessage,
          'languageCode': languageCode,
          'publicContext': gameContext,
          // Server attaches CHARACTER_PRIVATE / killer slice itself.
        }),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final spoken = body['spokenText'] as String?;
        if (spoken != null && spoken.isNotEmpty) return spoken;
      }
      debugPrint('Firebase AI chat failed: ${response.statusCode}');
    } catch (e) {
      debugPrint('Firebase AI chat error: $e');
    }

    return _fallback.getCharacterResponse(
      character,
      userMessage,
      gameContext,
      languageCode,
    );
  }
}
