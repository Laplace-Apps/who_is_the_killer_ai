import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_is_the_killer_ai/main.dart';
import 'package:who_is_the_killer_ai/providers/language_provider.dart';
import 'package:who_is_the_killer_ai/screens/authentication_screen.dart';
import 'package:who_is_the_killer_ai/screens/investigation_screen.dart';
import 'package:who_is_the_killer_ai/screens/home_screen.dart';
import 'package:who_is_the_killer_ai/screens/walkthrough_screen.dart';
import 'package:who_is_the_killer_ai/screens/welcome_screen.dart';
import 'package:who_is_the_killer_ai/services/auth_service.dart';

import 'support/fakes.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Firebase initialization failure renders safely', (tester) async {
    await tester.pumpWidget(const FirebaseInitializationErrorApp());

    expect(find.textContaining('Firebase başlatılamadı'), findsOneWidget);
  });

  testWidgets('first launch shows walkthrough and skip persists completion', (
    tester,
  ) async {
    final authService = FakeAuthService();
    final onboarding = MemoryOnboardingPreferences(completed: false);
    addTearDown(authService.dispose);

    await tester.pumpWidget(
      _buildApp(
        authService: authService,
        persistence: MemoryGamePersistence(),
        onboarding: onboarding,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(WalkthroughScreen), findsOneWidget);
    await tester.tap(find.text('Atla'));
    await tester.pumpAndSettle();

    expect(onboarding.completeCalls, 1);
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });

  testWidgets('returning signed-out user sees localized welcome', (
    tester,
  ) async {
    final authService = FakeAuthService();
    addTearDown(authService.dispose);

    await tester.pumpWidget(
      _buildApp(authService: authService, persistence: MemoryGamePersistence()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Giriş Yap'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.language));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets(
    'existing authenticated session bypasses pre-auth and opens Home',
    (tester) async {
      final authService = FakeAuthService(authenticated: true);
      final persistence = MemoryGamePersistence();
      addTearDown(authService.dispose);

      await tester.pumpWidget(
        _buildApp(
          authService: authService,
          persistence: persistence,
          onboarding: MemoryOnboardingPreferences(completed: false),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(WalkthroughScreen), findsNothing);
      expect(persistence.loadCalls, 1);
    },
  );

  testWidgets('successful email authentication opens Home', (tester) async {
    final authService = FakeAuthService();
    final persistence = MemoryGamePersistence();
    addTearDown(authService.dispose);

    await tester.pumpWidget(
      _buildApp(authService: authService, persistence: persistence),
    );
    await _openSignIn(tester);
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'player@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pumpAndSettle();

    expect(authService.signInCalls, 1);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(persistence.loadCalls, 1);
  });

  testWidgets('authentication validation and localized failure are shown', (
    tester,
  ) async {
    final authService = FakeAuthService(
      authenticationError: FirebaseAuthException(code: 'invalid-credential'),
    );
    addTearDown(authService.dispose);

    await tester.pumpWidget(
      _buildApp(authService: authService, persistence: MemoryGamePersistence()),
    );
    await _openSignIn(tester);

    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pump();
    expect(find.text('E-posta adresini gir.'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'player@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pump();

    expect(
      find.text('E-posta veya şifre hatalı. Bilgilerini kontrol et.'),
      findsOneWidget,
    );
  });

  testWidgets('password reset uses entered email and confirms delivery', (
    tester,
  ) async {
    final authService = FakeAuthService();
    addTearDown(authService.dispose);

    await tester.pumpWidget(
      _buildApp(authService: authService, persistence: MemoryGamePersistence()),
    );
    await _openSignIn(tester);
    await tester.enterText(
      find.byType(TextFormField).first,
      'player@example.com',
    );
    await tester.tap(find.text('Şifremi unuttum'));
    await tester.pump();

    expect(authService.resetPasswordCalls, 1);
    expect(
      find.text('Şifre sıfırlama bağlantısı e-postana gönderildi.'),
      findsOneWidget,
    );
  });

  testWidgets(
    'social providers are conditional and cancellation stays on auth',
    (tester) async {
      final authService = FakeAuthService(
        googleAvailable: true,
        appleAvailable: true,
        socialResult: AuthFlowResult.cancelled,
      );
      addTearDown(authService.dispose);

      await tester.pumpWidget(
        _buildApp(
          authService: authService,
          persistence: MemoryGamePersistence(),
        ),
      );
      await _openSignIn(tester);

      expect(find.text('Google ile devam et'), findsOneWidget);
      expect(find.text('Apple ile devam et'), findsOneWidget);
      await tester.tap(find.text('Google ile devam et'));
      await tester.pump();

      expect(authService.googleSignInCalls, 1);
      expect(find.byType(AuthenticationScreen), findsOneWidget);
    },
  );

  testWidgets('successful social authentication uses the same Home gate', (
    tester,
  ) async {
    final authService = FakeAuthService(googleAvailable: true);
    final persistence = MemoryGamePersistence();
    addTearDown(authService.dispose);

    await tester.pumpWidget(
      _buildApp(authService: authService, persistence: persistence),
    );
    await _openSignIn(tester);
    await tester.tap(find.text('Google ile devam et'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(persistence.loadCalls, 1);
  });

  testWidgets('game starts without replacing the authenticated identity', (
    tester,
  ) async {
    final authService = FakeAuthService(authenticated: true);
    final persistence = MemoryGamePersistence();
    addTearDown(authService.dispose);
    final languageProvider = LanguageProvider();

    await tester.pumpWidget(
      MyApp(
        languageProvider: languageProvider,
        authService: authService,
        gamePersistence: persistence,
        onboardingPreferences: MemoryOnboardingPreferences(),
      ),
    );
    await tester.pumpAndSettle();

    final startButton = find.text(languageProvider.t('start_game'));
    await tester.ensureVisible(startButton);
    await tester.tap(startButton);
    // Flame GameWidget keeps scheduling frames; avoid pumpAndSettle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.byType(InvestigationScreen), findsOneWidget);
    expect(authService.signInCalls, 0);
    expect(persistence.savedGameState?.characters.length, 6);
    expect(find.byIcon(Icons.menu_book), findsOneWidget);
    expect(find.byIcon(Icons.gavel), findsOneWidget);
  });
}

Future<void> _openSignIn(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('welcome-sign-in')));
  await tester.pumpAndSettle();
  expect(find.byType(AuthenticationScreen), findsOneWidget);
}

Widget _buildApp({
  required FakeAuthService authService,
  required MemoryGamePersistence persistence,
  MemoryOnboardingPreferences? onboarding,
}) {
  return MyApp(
    languageProvider: LanguageProvider(),
    authService: authService,
    gamePersistence: persistence,
    onboardingPreferences: onboarding ?? MemoryOnboardingPreferences(),
  );
}
