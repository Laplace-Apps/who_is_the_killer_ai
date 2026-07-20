import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

class AppCheckProviderConfiguration {
  const AppCheckProviderConfiguration({
    required this.androidProvider,
    required this.appleProvider,
  });

  factory AppCheckProviderConfiguration.forBuildMode({required bool isDebug}) {
    return AppCheckProviderConfiguration(
      androidProvider: isDebug
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
      appleProvider: isDebug
          ? const AppleDebugProvider()
          : const AppleAppAttestWithDeviceCheckFallbackProvider(),
    );
  }

  final AndroidAppCheckProvider androidProvider;
  final AppleAppCheckProvider appleProvider;

  static bool supportsPlatform({
    required bool isWeb,
    required TargetPlatform platform,
  }) {
    if (isWeb) return false;
    return platform == TargetPlatform.android || platform == TargetPlatform.iOS;
  }
}

class FirebaseAppCheckService {
  const FirebaseAppCheckService();

  Future<void> activate() async {
    if (!AppCheckProviderConfiguration.supportsPlatform(
      isWeb: kIsWeb,
      platform: defaultTargetPlatform,
    )) {
      return;
    }

    final providers = AppCheckProviderConfiguration.forBuildMode(
      isDebug: kDebugMode,
    );
    await FirebaseAppCheck.instance.activate(
      providerAndroid: providers.androidProvider,
      providerApple: providers.appleProvider,
    );
  }
}
