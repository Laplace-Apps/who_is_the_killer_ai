import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_the_killer_ai/services/app_check_service.dart';

void main() {
  test('debug builds select only native debug providers', () {
    final configuration = AppCheckProviderConfiguration.forBuildMode(
      isDebug: true,
    );

    expect(configuration.androidProvider, isA<AndroidDebugProvider>());
    expect(configuration.appleProvider, isA<AppleDebugProvider>());
  });

  test('release builds select real attestation providers', () {
    final configuration = AppCheckProviderConfiguration.forBuildMode(
      isDebug: false,
    );

    expect(configuration.androidProvider, isA<AndroidPlayIntegrityProvider>());
    expect(
      configuration.appleProvider,
      isA<AppleAppAttestWithDeviceCheckFallbackProvider>(),
    );
    expect(configuration.androidProvider, isNot(isA<AndroidDebugProvider>()));
    expect(configuration.appleProvider, isNot(isA<AppleDebugProvider>()));
  });

  test('mobile activation excludes web and desktop targets', () {
    expect(
      AppCheckProviderConfiguration.supportsPlatform(
        isWeb: false,
        platform: TargetPlatform.android,
      ),
      isTrue,
    );
    expect(
      AppCheckProviderConfiguration.supportsPlatform(
        isWeb: false,
        platform: TargetPlatform.iOS,
      ),
      isTrue,
    );
    expect(
      AppCheckProviderConfiguration.supportsPlatform(
        isWeb: true,
        platform: TargetPlatform.android,
      ),
      isFalse,
    );
    expect(
      AppCheckProviderConfiguration.supportsPlatform(
        isWeb: false,
        platform: TargetPlatform.windows,
      ),
      isFalse,
    );
  });
}
