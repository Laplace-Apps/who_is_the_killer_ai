import '../models/language.dart';

class Translations {
  static const Map<Language, Map<String, String>> _translations = {
    Language.turkish: {
      // Ana menü
      'app_title': 'Katil Kim? - Dedektif Oyunu',
      'start_game': 'Oyunu Başlat',
      'continue_game': 'Oyunu Devam Et',
      'settings': 'Ayarlar',
      'language': 'Dil',
      'about': 'Hakkında',

      // Oyun ekranı
      'game_title': 'Katil Kim?',
      'story_title': 'Apartman Cinayeti',
      'story_description':
          'Elif Yılmaz apartmanında ölü bulundu. Üç şüpheli var. Dedektif olarak gerçek katili bulmalısın!',
      'select_character': 'Karakter Seç',
      'chat_with_character': 'Karakterle Konuş',
      'make_decision': 'Karar Ver',
      'you_win': 'Tebrikler! Doğru tahmin ettin!',
      'you_lose': 'Yanlış tahmin! Gerçek katil:',
      'play_again': 'Tekrar Oyna',
      'back_to_menu': 'Ana Menüye Dön',

      // Karakterler
      'professor_name': 'Prof. Dr. Ahmet Yılmaz',
      'professor_role': 'Müzik Tarihi Profesörü',
      'professor_background':
          '20 yıldır üniversitede müzik tarihi dersi veriyor. Elif, onun araştırmasını çaldığını iddia ediyordu.',
      'professor_personality':
          'Entelektüel, detaycı, akademik bir yaklaşıma sahip.',

      'housewife_name': 'Ayşe Kaya',
      'housewife_role': 'Ev Hanımı',
      'housewife_background':
          '15 yıldır bu apartmanda yaşıyor. Elif, oğlunun işini kaybetmesine neden oldu.',
      'housewife_personality': 'Duygusal, dedikoducu, aile odaklı.',

      'guard_name': 'Mehmet Demir',
      'guard_role': 'Güvenlik Görevlisi',
      'guard_background':
          '5 yıldır apartmanda güvenlik görevlisi. Elif\'e borç para vermişti.',
      'guard_personality': 'Sessiz, gözlemci, güvenilir.',

      // Chat
      'type_message': 'Mesajınızı yazın...',
      'send': 'Gönder',
      'character_typing': 'Yazıyor...',
      'detective': 'Dedektif',
      'start_chat_with_character': 'ile konuşmaya başlayın',
      'ask_questions_for_clues': 'Sorular sorarak ipuçları toplayın',
      'suggested_questions': 'SORU ÖNERİLERİ:',
      'sorry_cannot_answer': 'Üzgünüm, şu anda cevap veremiyorum.',

      // İstatistikler
      'stats': 'İstatistikler',
      'total_games': 'Toplam Oyun',
      'correct_guesses': 'Doğru Tahmin',
      'accuracy': 'Doğruluk Oranı',
      'avg_conversations': 'Ortalama Konuşma',
      'avg_duration': 'Ortalama Süre',

      // Ayarlar
      'settings_title': 'Ayarlar',
      'select_language': 'Dil Seçin',
      'save_settings': 'Ayarları Kaydet',
      'reset_stats': 'İstatistikleri Sıfırla',

      // Hakkında
      'about_title': 'Hakkında',
      'about_description':
          'Katil Kim? - Yapay zeka destekli dedektif oyunu. Karakterlerle konuşarak gerçek katili bul!',
      'version': 'Versiyon',
      'developer': 'Geliştirici',

      // Oyun sonucu
      'congratulations': '🎉 TEBRİKLER!',
      'wrong_guess': '😔 YANLIŞ TAHMİN',
      'found_real_killer': 'Gerçek katili buldunuz!',
      'wrong_person_selected': 'Yanlış kişiyi seçtiniz.',
      'your_choice': 'Seçtiğiniz',
      'role': 'Rol',
      'real_killer': '🔍 GERÇEK KATİL',
      'new_game': 'YENİ OYUN',

      // Karar verme
      'final_decision': '🔍 SON KARAR',
      'decision_description':
          'Şüphelilerle konuştunuz. Şimdi gerçek katili seçin:',
      'cancel': 'İPTAL',
      'make_final_decision': '🔍 SON KARARIMI VER',

      // Oyun bilgileri
      'game_info': '🎯 OYUN BİLGİLERİ',
      'game_objective': 'OYUN AMACI:',
      'game_objective_text': '3 şüpheli arasından gerçek katili bulun!',
      'how_to_play': 'NASIL OYNANIR:',
      'how_to_play_1': '1. Şüphelilerle konuşarak bilgi toplayın',
      'how_to_play_2': '2. Her karakterin hikayesini dinleyin',
      'how_to_play_3': '3. Çelişkileri ve ipuçlarını bulun',
      'how_to_play_4': '4. Emin olduğunuzda bir şüpheliyi seçin',
      'clues': 'İPUÇLARI:',
      'clues_1': '- Her karakterin kendine özgü kişiliği var',
      'clues_2': '- Katil suçunu gizlemeye çalışır',
      'clues_3': '- Masumlar gerçeği söyler',
      'clues_4': '- Detaylara dikkat edin!',
      'question_suggestions': 'SORU ÖNERİLERİ:',
      'question_1': '- Cinayet gecesi neredeydiniz?',
      'question_2': '- Kurbanla ilişkiniz nasıldı?',
      'question_3': '- Herhangi bir çelişki var mı?',
      'ok': 'TAMAM',

      // Karakter bilgileri
      'character_info': 'Karakter Bilgileri',
      'background': 'Arka Plan',
      'personality': 'Kişilik',
      'alibi': 'Mazeret',
      'motive': 'Motif',

      // Oyun hikayesi
      'victim': 'Kurban',
      'crime_scene': 'Suç Mahalli',
      'detective_game': '🔍 Dedektif Oyunu',

      // Genel
      'loading': 'Yükleniyor...',
      'error': 'Hata',
      'success': 'Başarılı',
      'confirm': 'Onayla',
      'yes': 'Evet',
      'no': 'Hayır',

      // Soru önerileri
      'question_where_were_you': 'Cinayet gecesi neredeydiniz?',
      'question_relationship': 'Kurbanla aranızda nasıl bir ilişki vardı?',
      'question_last_meeting': 'Kurbanla son görüşmeniz ne zamandı?',
      'question_enmity': 'Kurbanın size karşı bir düşmanlığı var mıydı?',
      'question_heard_anything': 'Cinayet gecesi herhangi bir şey duydunuz mu?',
      'question_benefit': 'Kurbanın ölümünden kim faydalanabilir?',
      'question_last_argument': 'Kurbanla son tartışmanız ne hakkındaydı?',
      'question_with_who': 'Cinayet gecesi kimlerle birlikteydiniz?',
      'question_debt': 'Kurbanın size borcu var mıydı?',
      'question_who_could': 'Bu cinayeti kim yapmış olabilir?',
    },

    Language.english: {
      // Main menu
      'app_title': 'Who is the Killer? - Detective Game',
      'start_game': 'Start Game',
      'continue_game': 'Continue Game',
      'settings': 'Settings',
      'language': 'Language',
      'about': 'About',

      // Game screen
      'game_title': 'Who is the Killer?',
      'story_title': 'Apartment Murder',
      'story_description':
          'Elif Yılmaz was found dead in her apartment. There are three suspects. As a detective, you must find the real killer!',
      'select_character': 'Select Character',
      'chat_with_character': 'Chat with Character',
      'make_decision': 'Make Decision',
      'you_win': 'Congratulations! You guessed correctly!',
      'you_lose': 'Wrong guess! The real killer is:',
      'play_again': 'Play Again',
      'back_to_menu': 'Back to Menu',

      // Characters
      'professor_name': 'Prof. Dr. Ahmet Yılmaz',
      'professor_role': 'Music History Professor',
      'professor_background':
          'He has been teaching music history at university for 20 years. Elif claimed he stole her research.',
      'professor_personality':
          'Intellectual, detail-oriented, academic approach.',

      'housewife_name': 'Ayşe Kaya',
      'housewife_role': 'Housewife',
      'housewife_background':
          'She has been living in this apartment for 15 years. Elif caused her son to lose his job.',
      'housewife_personality': 'Emotional, gossipy, family-oriented.',

      'guard_name': 'Mehmet Demir',
      'guard_role': 'Security Guard',
      'guard_background':
          'He has been working as a security guard in the apartment for 5 years. He lent money to Elif.',
      'guard_personality': 'Quiet, observant, reliable.',

      // Chat
      'type_message': 'Type your message...',
      'send': 'Send',
      'character_typing': 'Typing...',
      'detective': 'Detective',
      'start_chat_with_character': 'Start chatting with',
      'ask_questions_for_clues': 'Ask questions to gather clues',
      'suggested_questions': 'SUGGESTED QUESTIONS:',
      'sorry_cannot_answer': 'Sorry, I cannot answer right now.',

      // Statistics
      'stats': 'Statistics',
      'total_games': 'Total Games',
      'correct_guesses': 'Correct Guesses',
      'accuracy': 'Accuracy Rate',
      'avg_conversations': 'Average Conversations',
      'avg_duration': 'Average Duration',

      // Settings
      'settings_title': 'Settings',
      'select_language': 'Select Language',
      'save_settings': 'Save Settings',
      'reset_stats': 'Reset Statistics',

      // About
      'about_title': 'About',
      'about_description':
          'Who is the Killer? - AI-powered detective game. Chat with characters to find the real killer!',
      'version': 'Version',
      'developer': 'Developer',

      // Game result
      'congratulations': '🎉 CONGRATULATIONS!',
      'wrong_guess': '😔 WRONG GUESS',
      'found_real_killer': 'You found the real killer!',
      'wrong_person_selected': 'You selected the wrong person.',
      'your_choice': 'Your choice',
      'role': 'Role',
      'real_killer': '🔍 REAL KILLER',
      'new_game': 'NEW GAME',

      // Decision making
      'final_decision': '🔍 FINAL DECISION',
      'decision_description':
          'You have talked to the suspects. Now choose the real killer:',
      'cancel': 'CANCEL',
      'make_final_decision': '🔍 MAKE MY FINAL DECISION',

      // Game information
      'game_info': '🎯 GAME INFORMATION',
      'game_objective': 'GAME OBJECTIVE:',
      'game_objective_text': 'Find the real killer among 3 suspects!',
      'how_to_play': 'HOW TO PLAY:',
      'how_to_play_1': '1. Gather information by talking to suspects',
      'how_to_play_2': '2. Listen to each character\'s story',
      'how_to_play_3': '3. Find contradictions and clues',
      'how_to_play_4': '4. Choose a suspect when you are sure',
      'clues': 'CLUES:',
      'clues_1': '- Each character has a unique personality',
      'clues_2': '- The killer tries to hide their crime',
      'clues_3': '- Innocent people tell the truth',
      'clues_4': '- Pay attention to details!',
      'question_suggestions': 'QUESTION SUGGESTIONS:',
      'question_1': '- Where were you on the night of the murder?',
      'question_2': '- What was your relationship with the victim?',
      'question_3': '- Are there any contradictions?',
      'ok': 'OK',

      // Character information
      'character_info': 'Character Information',
      'background': 'Background',
      'personality': 'Personality',
      'alibi': 'Alibi',
      'motive': 'Motive',

      // Game story
      'victim': 'Victim',
      'crime_scene': 'Crime Scene',
      'detective_game': '🔍 Detective Game',

      // General
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',

      // Question suggestions
      'question_where_were_you': 'Where were you on the night of the murder?',
      'question_relationship': 'What was your relationship with the victim?',
      'question_last_meeting': 'When was your last meeting with the victim?',
      'question_enmity': 'Did the victim have any hostility towards you?',
      'question_heard_anything':
          'Did you hear anything on the night of the murder?',
      'question_benefit': 'Who could benefit from the victim\'s death?',
      'question_last_argument':
          'What was your last argument with the victim about?',
      'question_with_who': 'Who were you with on the night of the murder?',
      'question_debt': 'Did the victim owe you money?',
      'question_who_could': 'Who could have committed this murder?',
    },
  };

  static String getText(String key, Language language) {
    return _translations[language]?[key] ?? key;
  }
}
