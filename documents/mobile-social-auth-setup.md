# Mobile social authentication setup

The Flutter implementation supports Google on Android/iOS and Apple on iOS.
The remaining provider setup needs account access that is not stored in this
repository.

## Current blocker

Firebase CLI credentials on this Windows host have expired. Reauthenticate:

```powershell
npx -y firebase-tools@latest login --reauth
npx -y firebase-tools@latest use who-is-the-killer-ai
```

Never commit Apple private keys, Firebase service-account credentials, or CLI
tokens.

## Firebase Authentication providers

In Firebase project `who-is-the-killer-ai`, enable:

1. Email/Password
2. Google
3. Apple

Set a project support email for Google. Apple additionally requires the Apple
Developer values described below.

## Android Google sign-in

1. The current debug signing key was inspected without launching the app:

   - SHA-1: `93:38:10:B4:BA:38:7B:0F:DD:86:D2:00:1F:FB:30:F7:62:65:E6:D9`
   - SHA-256: `0A:AF:9A:78:F4:C3:29:22:B4:59:EE:5D:C9:74:F6:19:97:14:ED:49:34:B6:C6:CF:80:DA:EE:FC:7A:2C:12:A9`

   Regenerate them when the signing key changes:

   ```powershell
   .\android\gradlew.bat -p android signingReport
   ```

2. Add the release and debug SHA-1 and SHA-256 fingerprints to the Android app
   `com.laplaceapps.who_is_the_killer_ai` in Firebase.
3. Fetch the regenerated SDK config:

   ```powershell
   npx -y firebase-tools@latest apps:sdkconfig ANDROID 1:1041354935724:android:4a9a3f1f9b9420e693be09 --project who-is-the-killer-ai | Out-File -Encoding utf8 android/app/google-services.json
   ```

4. Confirm `android/app/google-services.json` now contains an OAuth client with
   `client_type: 3`. The current checked-in file has no OAuth clients, so Google
   sign-in cannot succeed until it is regenerated.

## iOS Google sign-in

1. Fetch the iOS SDK config:

   ```powershell
   npx -y firebase-tools@latest apps:sdkconfig IOS 1:1041354935724:ios:c904a4185663b22993be09 --project who-is-the-killer-ai | Out-File -Encoding utf8 ios/Runner/GoogleService-Info.plist
   ```

2. On macOS, open `ios/Runner.xcworkspace` in Xcode and add
   `GoogleService-Info.plist` to the Runner target.
3. Copy `REVERSED_CLIENT_ID` from that plist into a URL Type for the Runner
   target.

Do not guess or copy OAuth client IDs from another app.

## iOS Apple sign-in

1. In Apple Developer, enable Sign in with Apple for bundle ID
   `com.laplaceapps.whoIsTheKillerAi`.
2. Create a Sign in with Apple key and record its Team ID and Key ID.
3. Configure the Firebase Apple provider with those values and its private key.
4. On macOS, open `ios/Runner.xcworkspace`, select Runner, then add the
   **Sign in with Apple** capability. Xcode must link
   `ios/Runner/Runner.entitlements` through the Code Signing Entitlements build
   setting.

The entitlement file is present in the repository, but the `.pbxproj` was not
edited on Windows because safe Xcode project signing changes require Xcode.

## Device verification

- Android: verify Google success, cancellation, and disabled-provider errors.
- iOS: verify Google and Apple success/cancellation on a physical device.
- Confirm every successful provider updates Firebase Auth and reaches the same
  `AuthGate`/user-scoped game data flow as email authentication.
