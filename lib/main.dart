import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/game_provider.dart';
import 'providers/language_provider.dart';
import 'screens/authentication_screen.dart';
import 'screens/home_screen.dart';
import 'screens/walkthrough_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/ai_chat_service.dart';
import 'services/app_check_service.dart';
import 'services/auth_service.dart';
import 'services/game_persistence.dart';
import 'services/onboarding_preferences.dart';
import 'theme/mystery_theme.dart';

/// Optional Cloud Function URL for server-side interrogation prompt assembly.
/// Pass with: `--dart-define=INTERROGATE_FUNCTION_URL=https://...`
const String kInterrogateFunctionUrl = String.fromEnvironment(
  'INTERROGATE_FUNCTION_URL',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await const FirebaseAppCheckService().activate();
  } catch (error, stackTrace) {
    debugPrint('Firebase güvenlik başlatma hatası: $error');
    debugPrintStack(stackTrace: stackTrace);
    runApp(const FirebaseInitializationErrorApp());
    return;
  }

  // Dil tercihini yükle
  final languageProvider = LanguageProvider();
  await languageProvider.loadSavedLanguage();

  final chatService = FirebaseAiCharacterChatService(
    functionUrl: kInterrogateFunctionUrl.isEmpty
        ? null
        : kInterrogateFunctionUrl,
  );

  runApp(
    MyApp(
      languageProvider: languageProvider,
      authService: FirebaseAuthService(),
      gamePersistence: FirebaseGamePersistence(),
      onboardingPreferences: SharedPreferencesOnboardingPreferences(),
      chatService: chatService,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.languageProvider,
    required this.authService,
    required this.gamePersistence,
    required this.onboardingPreferences,
    this.chatService = const LocalMockCharacterChatService(),
  });

  final LanguageProvider languageProvider;
  final AuthService authService;
  final GamePersistence gamePersistence;
  final OnboardingPreferences onboardingPreferences;
  final CharacterChatService chatService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        ChangeNotifierProvider(
          create: (context) => GameProvider(
            chatService: chatService,
            gamePersistence: gamePersistence,
          ),
        ),
        ChangeNotifierProvider.value(value: languageProvider),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: languageProvider.t('app_title'),
            theme: MysteryTheme.dark(),
            home: AuthGate(
              authService: authService,
              onboardingPreferences: onboardingPreferences,
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

enum _PreAuthDestination { welcome, signIn, signUp }

class AuthGate extends StatefulWidget {
  const AuthGate({
    super.key,
    required this.authService,
    required this.onboardingPreferences,
  });

  final AuthService authService;
  final OnboardingPreferences onboardingPreferences;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Future<bool> _onboardingCompleted;
  _PreAuthDestination _destination = _PreAuthDestination.welcome;

  @override
  void initState() {
    super.initState();
    _onboardingCompleted = widget.onboardingPreferences.isCompleted();
  }

  void _completeWalkthrough() {
    setState(() {
      _onboardingCompleted = Future.value(true);
      _destination = _PreAuthDestination.welcome;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.authService.authenticationChanges,
      initialData: widget.authService.isAuthenticated,
      builder: (context, snapshot) {
        if (snapshot.data ?? false) {
          return const AuthenticatedHome();
        }
        return FutureBuilder<bool>(
          future: _onboardingCompleted,
          builder: (context, onboardingSnapshot) {
            if (onboardingSnapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!(onboardingSnapshot.data ?? false)) {
              return WalkthroughScreen(
                preferences: widget.onboardingPreferences,
                onCompleted: _completeWalkthrough,
              );
            }

            if (_destination == _PreAuthDestination.welcome) {
              return WelcomeScreen(
                onSignIn: () {
                  setState(() => _destination = _PreAuthDestination.signIn);
                },
                onCreateAccount: () {
                  setState(() => _destination = _PreAuthDestination.signUp);
                },
              );
            }

            return AuthenticationScreen(
              authService: widget.authService,
              initialSignUp: _destination == _PreAuthDestination.signUp,
              onBack: () {
                setState(() => _destination = _PreAuthDestination.welcome);
              },
            );
          },
        );
      },
    );
  }
}

class AuthenticatedHome extends StatefulWidget {
  const AuthenticatedHome({super.key});

  @override
  State<AuthenticatedHome> createState() => _AuthenticatedHomeState();
}

class _AuthenticatedHomeState extends State<AuthenticatedHome> {
  Future<void>? _loadGameFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadGameFuture ??= context.read<GameProvider>().loadGameState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadGameFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Color(0xFF0B121A),
            body: SizedBox.expand(),
          );
        }
        return const HomeScreen();
      },
    );
  }
}

class FirebaseInitializationErrorApp extends StatelessWidget {
  const FirebaseInitializationErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Firebase başlatılamadı. Uygulamayı tamamen kapatıp yeniden açın.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
