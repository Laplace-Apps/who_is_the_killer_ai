import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_the_killer_ai/main.dart';
import 'package:who_is_the_killer_ai/providers/language_provider.dart';
import 'package:who_is_the_killer_ai/screens/authentication_screen.dart';
import 'package:who_is_the_killer_ai/screens/game_screen.dart';
import 'package:who_is_the_killer_ai/screens/home_screen.dart';
import 'package:who_is_the_killer_ai/widgets/character_card.dart';
import 'package:who_is_the_killer_ai/widgets/decision_dialog.dart';

import 'support/fakes.dart';

void main() {
  testWidgets('Firebase initialization failure renders safely', (tester) async {
    await tester.pumpWidget(const FirebaseInitializationErrorApp());

    expect(find.textContaining('Firebase başlatılamadı'), findsOneWidget);
  });

  testWidgets('existing authenticated session opens Home', (tester) async {
    final authService = FakeAuthService(authenticated: true);
    final persistence = MemoryGamePersistence();
    addTearDown(authService.dispose);

    await tester.pumpWidget(
      _buildApp(authService: authService, persistence: persistence),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(persistence.loadCalls, 1);
  });

  testWidgets('successful authentication opens Home', (tester) async {
    final authService = FakeAuthService();
    final persistence = MemoryGamePersistence();
    addTearDown(authService.dispose);

    await tester.pumpWidget(
      _buildApp(authService: authService, persistence: persistence),
    );

    expect(find.byType(AuthenticationScreen), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'player@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password');
    await tester.tap(find.text('Giriş Yap'));
    await tester.pumpAndSettle();

    expect(authService.signInCalls, 1);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('authentication failure displays an error', (tester) async {
    final authService = FakeAuthService(
      authenticationError: FirebaseAuthException(code: 'wrong-password'),
    );
    addTearDown(authService.dispose);

    await tester.pumpWidget(
      _buildApp(authService: authService, persistence: MemoryGamePersistence()),
    );

    await tester.enterText(find.byType(TextField).at(0), 'player@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'wrong');
    await tester.tap(find.text('Giriş Yap'));
    await tester.pump();

    expect(find.text('Yanlış şifre.'), findsOneWidget);
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
      ),
    );
    await tester.pumpAndSettle();

    final startButton = find.text(languageProvider.t('start_game'));
    await tester.ensureVisible(startButton);
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    expect(find.byType(GameScreen), findsOneWidget);
    expect(authService.signInCalls, 0);
    expect(persistence.savedGameState?.characters.length, 3);
  });

  testWidgets('accusation dialog opens with the current suspects', (
    tester,
  ) async {
    final authService = FakeAuthService(authenticated: true);
    addTearDown(authService.dispose);
    final languageProvider = LanguageProvider();

    await tester.pumpWidget(
      MyApp(
        languageProvider: languageProvider,
        authService: authService,
        gamePersistence: MemoryGamePersistence(),
      ),
    );
    await tester.pumpAndSettle();
    final startButton = find.text(languageProvider.t('start_game'));
    await tester.ensureVisible(startButton);
    await tester.tap(startButton);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CharacterCard).first);
    await tester.pump();

    final decisionButton = find.text(languageProvider.t('make_final_decision'));
    await tester.ensureVisible(decisionButton);
    await tester.tap(decisionButton);
    await tester.pumpAndSettle();

    expect(find.byType(DecisionDialog), findsOneWidget);
    final dialog = find.byType(DecisionDialog);
    expect(
      find.descendant(
        of: dialog,
        matching: find.text('Prof. Dr. Ahmet Yılmaz'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: dialog, matching: find.text('Ayşe Kaya')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: dialog, matching: find.text('Mehmet Demir')),
      findsOneWidget,
    );
  });
}

Widget _buildApp({
  required FakeAuthService authService,
  required MemoryGamePersistence persistence,
}) {
  return MyApp(
    languageProvider: LanguageProvider(),
    authService: authService,
    gamePersistence: persistence,
  );
}
