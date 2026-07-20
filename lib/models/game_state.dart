import 'character.dart';

class GameState {
  final String storyTitle;
  final String storyDescription;
  final String crimeScene;
  final String victim;
  final List<Character> characters;
  final Character? selectedKiller;
  final bool gameCompleted;
  final Map<String, List<String>> characterConversations;
  final String currentRoomId;
  final double playerX;
  final double playerY;
  final List<String> discoveredClueIds;
  final List<String> unlockedLocationIds;
  final List<String> requiredAccusationClueIds;
  final String? proximityPrompt;

  GameState({
    required this.storyTitle,
    required this.storyDescription,
    required this.crimeScene,
    required this.victim,
    required this.characters,
    this.selectedKiller,
    this.gameCompleted = false,
    this.characterConversations = const {},
    this.currentRoomId = 'location_03',
    this.playerX = 400,
    this.playerY = 320,
    this.discoveredClueIds = const [],
    this.unlockedLocationIds = const [
      'location_01',
      'location_02',
      'location_03',
      'location_04',
      'location_05',
    ],
    this.requiredAccusationClueIds = const [
      'clue_07',
      'clue_10',
      'clue_11',
      'clue_17',
    ],
    this.proximityPrompt,
  });

  bool get canAccuse {
    return requiredAccusationClueIds.every(discoveredClueIds.contains);
  }

  Set<String> get missingAccusationClues {
    return requiredAccusationClueIds
        .where((id) => !discoveredClueIds.contains(id))
        .toSet();
  }

  GameState copyWith({
    String? storyTitle,
    String? storyDescription,
    String? crimeScene,
    String? victim,
    List<Character>? characters,
    Character? selectedKiller,
    bool? gameCompleted,
    Map<String, List<String>>? characterConversations,
    String? currentRoomId,
    double? playerX,
    double? playerY,
    List<String>? discoveredClueIds,
    List<String>? unlockedLocationIds,
    List<String>? requiredAccusationClueIds,
    String? proximityPrompt,
    bool clearProximityPrompt = false,
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
      currentRoomId: currentRoomId ?? this.currentRoomId,
      playerX: playerX ?? this.playerX,
      playerY: playerY ?? this.playerY,
      discoveredClueIds: discoveredClueIds ?? this.discoveredClueIds,
      unlockedLocationIds: unlockedLocationIds ?? this.unlockedLocationIds,
      requiredAccusationClueIds:
          requiredAccusationClueIds ?? this.requiredAccusationClueIds,
      proximityPrompt: clearProximityPrompt
          ? null
          : (proximityPrompt ?? this.proximityPrompt),
    );
  }

  List<String> getConversationForCharacter(String characterName) {
    return characterConversations[characterName] ?? [];
  }

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
      'currentRoomId': currentRoomId,
      'playerX': playerX,
      'playerY': playerY,
      'discoveredClueIds': discoveredClueIds,
      'unlockedLocationIds': unlockedLocationIds,
      'requiredAccusationClueIds': requiredAccusationClueIds,
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      storyTitle: json['storyTitle'] as String,
      storyDescription: json['storyDescription'] as String,
      crimeScene: json['crimeScene'] as String,
      victim: json['victim'] as String,
      characters: (json['characters'] as List)
          .map((c) => Character.fromJson(c as Map<String, dynamic>))
          .toList(),
      selectedKiller: json['selectedKiller'] != null
          ? Character.fromJson(json['selectedKiller'] as Map<String, dynamic>)
          : null,
      gameCompleted: json['gameCompleted'] as bool? ?? false,
      characterConversations:
          (json['characterConversations'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<String>.from(value as List)),
          ) ??
          {},
      currentRoomId: json['currentRoomId'] as String? ?? 'location_03',
      playerX: (json['playerX'] as num?)?.toDouble() ?? 400,
      playerY: (json['playerY'] as num?)?.toDouble() ?? 320,
      discoveredClueIds: List<String>.from(
        json['discoveredClueIds'] as List? ?? const [],
      ),
      unlockedLocationIds: List<String>.from(
        json['unlockedLocationIds'] as List? ??
            const [
              'location_01',
              'location_02',
              'location_03',
              'location_04',
              'location_05',
            ],
      ),
      requiredAccusationClueIds: List<String>.from(
        json['requiredAccusationClueIds'] as List? ??
            const ['clue_07', 'clue_10', 'clue_11', 'clue_17'],
      ),
    );
  }
}
