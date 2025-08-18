import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/language.dart';
import '../localization/translations.dart';

class LanguageProvider with ChangeNotifier {
  Language _currentLanguage = Language.turkish;

  Language get currentLanguage => _currentLanguage;

  // Metin getirme fonksiyonu
  String t(String key) {
    return Translations.getText(key, _currentLanguage);
  }

  // Dil değiştirme
  Future<void> changeLanguage(Language language) async {
    if (_currentLanguage != language) {
      _currentLanguage = language;

      // Dil tercihini kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', language.code);

      notifyListeners();
    }
  }

  // Kaydedilmiş dil tercihini yükle
  Future<void> loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString('language');

      if (savedLanguageCode != null) {
        _currentLanguage = Language.fromCode(savedLanguageCode);
        notifyListeners();
      }
    } catch (e) {
      print('Dil tercihi yüklenemedi: $e');
    }
  }

  // Desteklenen dilleri getir
  List<Language> get supportedLanguages => Language.values;
}
