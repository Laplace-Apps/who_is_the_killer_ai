import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/game_provider.dart';
import 'providers/language_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i opsiyonel olarak başlat
  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseInitialized = true;
    print('Firebase başarıyla başlatıldı');
  } catch (e) {
    print('Firebase başlatma hatası: $e');
    print('Uygulama Firebase olmadan çalışacak');
  }

  // Dil tercihini yükle
  final languageProvider = LanguageProvider();
  await languageProvider.loadSavedLanguage();

  runApp(MyApp(languageProvider: languageProvider));
}

class MyApp extends StatelessWidget {
  final LanguageProvider languageProvider;

  const MyApp({super.key, required this.languageProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameProvider()),
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
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
