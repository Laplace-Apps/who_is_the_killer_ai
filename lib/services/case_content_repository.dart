import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/character.dart';
import '../models/game_state.dart';
import '../models/language.dart';

class CaseClueInfo {
  const CaseClueInfo({
    required this.id,
    required this.titleEn,
    required this.titleTr,
    required this.descEn,
    required this.descTr,
  });

  final String id;
  final String titleEn;
  final String titleTr;
  final String descEn;
  final String descTr;

  String title(Language language) =>
      language == Language.turkish ? titleTr : titleEn;

  String description(Language language) =>
      language == Language.turkish ? descTr : descEn;

  factory CaseClueInfo.fromJson(Map<String, dynamic> json) {
    return CaseClueInfo(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String,
      titleTr: json['titleTr'] as String,
      descEn: json['descEn'] as String,
      descTr: json['descTr'] as String,
    );
  }
}

class CasePublicContent {
  CasePublicContent({
    required this.caseId,
    required this.titleEn,
    required this.titleTr,
    required this.descriptionEn,
    required this.descriptionTr,
    required this.victimEn,
    required this.victimTr,
    required this.crimeSceneEn,
    required this.crimeSceneTr,
    required this.requiredAccusationClueIds,
    required this.rawSuspects,
    required this.clues,
  });

  final String caseId;
  final String titleEn;
  final String titleTr;
  final String descriptionEn;
  final String descriptionTr;
  final String victimEn;
  final String victimTr;
  final String crimeSceneEn;
  final String crimeSceneTr;
  final List<String> requiredAccusationClueIds;
  final List<Map<String, dynamic>> rawSuspects;
  final List<CaseClueInfo> clues;

  CaseClueInfo? clueById(String id) {
    for (final clue in clues) {
      if (clue.id == id) return clue;
    }
    return null;
  }

  factory CasePublicContent.fromJson(Map<String, dynamic> json) {
    return CasePublicContent(
      caseId: json['caseId'] as String,
      titleEn: json['titleEn'] as String,
      titleTr: json['titleTr'] as String,
      descriptionEn: json['descriptionEn'] as String,
      descriptionTr: json['descriptionTr'] as String,
      victimEn: json['victimEn'] as String,
      victimTr: json['victimTr'] as String,
      crimeSceneEn: json['crimeSceneEn'] as String,
      crimeSceneTr: json['crimeSceneTr'] as String,
      requiredAccusationClueIds: List<String>.from(
        json['requiredAccusationClueIds'] as List,
      ),
      rawSuspects: (json['suspects'] as List)
          .cast<Map<String, dynamic>>()
          .toList(),
      clues: (json['clues'] as List)
          .map((c) => CaseClueInfo.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  List<Character> buildCharacters(Language language) {
    return rawSuspects.map((s) {
      final colorHex =
          (s['color'] as String? ?? '#4A6A7A').replaceFirst('#', '');
      final isTr = language == Language.turkish;
      return Character(
        id: s['id'] as String,
        name: (isTr ? s['nameTr'] : s['nameEn']) as String,
        role: (isTr ? s['roleTr'] : s['roleEn']) as String,
        background: (isTr ? s['backgroundTr'] : s['backgroundEn']) as String,
        personality:
            (isTr ? s['personalityTr'] : s['personalityEn']) as String,
        alibi: (isTr ? s['alibiTr'] : s['alibiEn']) as String,
        motive: '',
        isKiller: false,
        avatar: s['avatar'] as String? ?? '👤',
        colorValue: int.parse('FF$colorHex', radix: 16),
      );
    }).toList();
  }

  GameState toGameState(Language language) {
    return GameState(
      storyTitle: language == Language.turkish ? titleTr : titleEn,
      storyDescription:
          language == Language.turkish ? descriptionTr : descriptionEn,
      crimeScene: language == Language.turkish ? crimeSceneTr : crimeSceneEn,
      victim: language == Language.turkish ? victimTr : victimEn,
      characters: buildCharacters(language),
      requiredAccusationClueIds: requiredAccusationClueIds,
    );
  }
}

/// Loads only PUBLIC/DISCOVERABLE case slices bundled as assets.
class CaseContentRepository {
  CaseContentRepository({
    this.assetPath =
        'assets/cases/whispering_observatory/case_public.json',
  });

  final String assetPath;
  CasePublicContent? _cached;

  Future<CasePublicContent> loadPublicCase() async {
    if (_cached != null) return _cached!;
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _cached = CasePublicContent.fromJson(json);
    return _cached!;
  }
}
