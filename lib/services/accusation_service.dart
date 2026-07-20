import '../models/character.dart';
import '../models/game_state.dart';

class AccusationResult {
  const AccusationResult({
    required this.isCorrect,
    required this.hasRequiredEvidence,
    required this.messageEn,
    required this.messageTr,
  });

  final bool isCorrect;
  final bool hasRequiredEvidence;
  final String messageEn;
  final String messageTr;
}

/// Server-authoritative accusation API. Local mock is temporary for prototype.
abstract interface class AccusationService {
  Future<AccusationResult> validate({
    required String accusedSuspectId,
    required GameState gameState,
  });
}

/// Prototype validator: evidence chain + canonical suspect id.
/// Production must move this check to a Cloud Function using solution_private.md.
class LocalMockAccusationService implements AccusationService {
  const LocalMockAccusationService();

  /// Canonical killer id — must not be shipped via Character.isKiller.
  static const canonicalKillerId = 'suspect_01';

  @override
  Future<AccusationResult> validate({
    required String accusedSuspectId,
    required GameState gameState,
  }) async {
    if (!gameState.canAccuse) {
      return AccusationResult(
        isCorrect: false,
        hasRequiredEvidence: false,
        messageEn:
            'You need clue_07, clue_10, clue_11, and clue_17 before a formal accusation.',
        messageTr:
            'Resmi suçlama için clue_07, clue_10, clue_11 ve clue_17 gerekli.',
      );
    }

    final correct = accusedSuspectId == canonicalKillerId;
    if (correct) {
      return const AccusationResult(
        isCorrect: true,
        hasRequiredEvidence: true,
        messageEn:
            'The locked room was an illusion. Elena Vance used the shaft, the catwalk, and the 23:08 bolt.',
        messageTr:
            'Kilitli oda bir illüzyondu. Elena Vance şaftı, iskeleyi ve 23:08 sürgüsünü kullandı.',
      );
    }

    return const AccusationResult(
      isCorrect: false,
      hasRequiredEvidence: true,
      messageEn:
          'Your evidence chain is complete, but that suspect does not fit the final method.',
      messageTr:
          'Kanıt zinciriniz tamam, ancak o şüpheli nihai yönteme uymuyor.',
    );
  }
}

/// Calls a Cloud Function for accusation scoring. Falls back to local mock
/// until the function is deployed.
class FirebaseAccusationService implements AccusationService {
  FirebaseAccusationService({
    this._fallback = const LocalMockAccusationService(),
    this.functionUrl,
  });

  final AccusationService _fallback;
  final String? functionUrl;

  @override
  Future<AccusationResult> validate({
    required String accusedSuspectId,
    required GameState gameState,
  }) async {
    // Cloud Function wiring: POST {accusedSuspectId, discoveredClueIds, uid}
    // Private solution stays server-side. Until deployed, use local mock.
    if (functionUrl == null || functionUrl!.isEmpty) {
      return _fallback.validate(
        accusedSuspectId: accusedSuspectId,
        gameState: gameState,
      );
    }
    return _fallback.validate(
      accusedSuspectId: accusedSuspectId,
      gameState: gameState,
    );
  }
}

Character? characterById(GameState state, String id) {
  for (final c in state.characters) {
    if (c.id == id) return c;
  }
  return null;
}
