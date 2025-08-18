import 'character.dart';

class GameState {
  final String storyTitle;
  final String storyDescription;
  final String crimeScene;
  final String victim;
  final List<Character> characters;
  final Character? selectedKiller;
  final bool gameCompleted;
  final Map<String, List<String>>
  characterConversations; // Her karakter için ayrı konuşma geçmişi

  GameState({
    required this.storyTitle,
    required this.storyDescription,
    required this.crimeScene,
    required this.victim,
    required this.characters,
    this.selectedKiller,
    this.gameCompleted = false,
    this.characterConversations = const {},
  });

  GameState copyWith({
    String? storyTitle,
    String? storyDescription,
    String? crimeScene,
    String? victim,
    List<Character>? characters,
    Character? selectedKiller,
    bool? gameCompleted,
    Map<String, List<String>>? characterConversations,
  }) {
    return GameState(
      storyTitle: storyTitle ?? this.storyTitle,
      storyDescription: storyDescription ?? this.storyDescription,
      crimeScene: crimeScene ?? this.crimeScene,
      victim: victim ?? this.victim,
      characters: characters ?? this.characters,
      selectedKiller: selectedKiller ?? this.selectedKiller,
      gameCompleted: gameCompleted ?? this.gameCompleted,
      characterConversations:
          characterConversations ?? this.characterConversations,
    );
  }

  // Belirli bir karakterin konuşma geçmişini al
  List<String> getConversationForCharacter(String characterName) {
    return characterConversations[characterName] ?? [];
  }

  // Belirli bir karakterin konuşma geçmişini güncelle
  GameState updateConversationForCharacter(
    String characterName,
    List<String> conversation,
  ) {
    final updatedConversations = Map<String, List<String>>.from(
      characterConversations,
    );
    updatedConversations[characterName] = conversation;
    return copyWith(characterConversations: updatedConversations);
  }

  Map<String, dynamic> toJson() {
    return {
      'storyTitle': storyTitle,
      'storyDescription': storyDescription,
      'crimeScene': crimeScene,
      'victim': victim,
      'characters': characters.map((c) => c.toJson()).toList(),
      'selectedKiller': selectedKiller?.toJson(),
      'gameCompleted': gameCompleted,
      'characterConversations': characterConversations,
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      storyTitle: json['storyTitle'],
      storyDescription: json['storyDescription'],
      crimeScene: json['crimeScene'],
      victim: json['victim'],
      characters: (json['characters'] as List)
          .map((c) => Character.fromJson(c))
          .toList(),
      selectedKiller: json['selectedKiller'] != null
          ? Character.fromJson(json['selectedKiller'])
          : null,
      gameCompleted: json['gameCompleted'] ?? false,
      characterConversations:
          (json['characterConversations'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
          ) ??
          {},
    );
  }
}
