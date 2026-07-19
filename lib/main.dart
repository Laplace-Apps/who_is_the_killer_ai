import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/game_provider.dart';
import 'providers/language_provider.dart';
import 'screens/authentication_screen.dart';
import 'screens/home_screen.dart';
import 'services/ai_chat_service.dart';
import 'services/auth_service.dart';
import 'services/game_persistence.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error, stackTrace) {
    debugPrint('Firebase başlatma hatası: $error');
    debugPrintStack(stackTrace: stackTrace);
    runApp(const FirebaseInitializationErrorApp());
    return;
  }

  // Dil tercihini yükle
  final languageProvider = LanguageProvider();
  await languageProvider.loadSavedLanguage();

  runApp(
    MyApp(
      languageProvider: languageProvider,
      authService: FirebaseAuthService(),
      gamePersistence: FirebaseGamePersistence(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.languageProvider,
    required this.authService,
    required this.gamePersistence,
    this.chatService = const LocalMockCharacterChatService(),
  });

  final LanguageProvider languageProvider;
  final AuthService authService;
  final GamePersistence gamePersistence;
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
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFe94560),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            home: AuthGate(authService: authService),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: authService.authenticationChanges,
      initialData: authService.isAuthenticated,
      builder: (context, snapshot) {
        if (snapshot.data ?? false) {
          return const AuthenticatedHome();
        }
        return AuthenticationScreen(authService: authService);
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
            body: Center(child: CircularProgressIndicator()),
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
