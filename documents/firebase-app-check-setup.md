# Firebase App Check setup

The app uses native debug providers in debug builds and real attestation
providers in release builds. Debug tokens are never loaded from Dart or bundled
into an application binary.

## Revoke the exposed token

The previous debug token was exposed and removed from the local `.env` file.
Revoke it before using App Check:

1. Open Firebase Console for project `who-is-the-killer-ai`.
2. Go to **App Check** and open the app's overflow menu.
3. Select **Manage debug tokens**.
4. Delete the exposed token.

Do not reuse that token, commit replacement tokens, or share debug builds with
untrusted users.

## Register development devices

1. Start a debug build on the Android emulator/device or iOS simulator/device.
2. Trigger a Firebase request.
3. Copy the App Check debug token printed by the native Firebase SDK.
4. In Firebase Console, open **App Check > Manage debug tokens** for the
   matching Android or iOS app.
5. Register the token with a descriptive device name.

Each developer and CI environment should use its own revocable token.

## Configure release providers

### Android

1. Register the Android app with App Check.
2. Select **Play Integrity**.
3. Ensure the release signing certificate SHA-256 is registered in Firebase.
4. Link the Google Cloud project to the Play Console application where
   required.

The current Gradle release configuration still uses the debug signing key and
must be replaced with a production signing configuration before release.

### iOS

1. Register the iOS app with App Check.
2. Enable App Attest for bundle ID `com.laplaceapps.whoIsTheKillerAi`.
3. On macOS, open `ios/Runner.xcworkspace` and add the App Attest capability to
   the Runner target.
4. Confirm signing entitlements and provisioning profiles include the
   capability.

The release provider falls back to DeviceCheck when App Attest is unavailable.
Do not edit the Xcode project file manually from Windows.

## Enforcement rollout

1. Leave enforcement disabled while collecting App Check metrics.
2. Verify legitimate Android and iOS release builds receive valid tokens.
3. Enable enforcement for Firestore.
4. Enable enforcement for protected Cloud Functions and Firebase AI endpoints
   after those services are deployed and verified.
5. Monitor rejected-request metrics during rollout.

Authentication alone does not authorize data access; Firestore rules and
server-side authorization remain required.
