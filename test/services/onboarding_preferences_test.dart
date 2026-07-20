import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_is_the_killer_ai/services/onboarding_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('stores a versioned onboarding completion', () async {
    final preferences = SharedPreferencesOnboardingPreferences(
      currentVersion: 2,
    );

    expect(await preferences.isCompleted(), isFalse);

    await preferences.markCompleted();

    expect(await preferences.isCompleted(), isTrue);
  });

  test('a newer walkthrough version is shown again', () async {
    final versionOne = SharedPreferencesOnboardingPreferences();
    await versionOne.markCompleted();

    final versionTwo = SharedPreferencesOnboardingPreferences(
      currentVersion: 2,
    );

    expect(await versionTwo.isCompleted(), isFalse);
  });
}
