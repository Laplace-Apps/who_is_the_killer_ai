import 'package:shared_preferences/shared_preferences.dart';

typedef SharedPreferencesLoader = Future<SharedPreferences> Function();

abstract interface class OnboardingPreferences {
  Future<bool> isCompleted();

  Future<void> markCompleted();
}

class SharedPreferencesOnboardingPreferences implements OnboardingPreferences {
  SharedPreferencesOnboardingPreferences({
    this.currentVersion = 1,
    SharedPreferencesLoader? preferencesLoader,
  }) : _preferencesLoader = preferencesLoader ?? SharedPreferences.getInstance;

  static const _versionKey = 'onboarding_version';

  final int currentVersion;
  final SharedPreferencesLoader _preferencesLoader;

  @override
  Future<bool> isCompleted() async {
    final preferences = await _preferencesLoader();
    final savedVersion = preferences.getInt(_versionKey) ?? 0;
    return savedVersion >= currentVersion;
  }

  @override
  Future<void> markCompleted() async {
    final preferences = await _preferencesLoader();
    await preferences.setInt(_versionKey, currentVersion);
  }
}
