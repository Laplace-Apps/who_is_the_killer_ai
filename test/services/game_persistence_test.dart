import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_is_the_killer_ai/data/game_data.dart';
import 'package:who_is_the_killer_ai/services/game_persistence.dart';

import '../support/fakes.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('saves remotely and restores from the local fallback', () async {
    final firebaseService = FakeFirebaseService();
    final persistence = FirebaseGamePersistence(
      firebaseService: firebaseService,
    );
    final gameState = GameData.createNewGame();

    await persistence.saveGameState(gameState);
    firebaseService.remoteGameState = null;
    final restoredState = await persistence.loadGameState();

    expect(restoredState?.storyTitle, gameState.storyTitle);
    expect(restoredState?.characters, hasLength(3));
  });

  test('clears local and remote game state', () async {
    final firebaseService = FakeFirebaseService();
    final persistence = FirebaseGamePersistence(
      firebaseService: firebaseService,
    );
    await persistence.saveGameState(GameData.createNewGame());

    await persistence.clearGameState();

    expect(await persistence.loadGameState(), isNull);
    expect(firebaseService.deleteCalls, 1);
  });
}
