import '../models/character.dart';
import '../models/game_state.dart';
import '../models/language.dart';
import '../localization/translations.dart';

class GameData {
  static GameState createNewGame([Language language = Language.turkish]) {
    final characters = [
      Character(
        name: Translations.getText('professor_name', language),
        role: Translations.getText('professor_role', language),
        background: Translations.getText('professor_background', language),
        personality: Translations.getText('professor_personality', language),
        alibi: 'Cinayet sırasında kütüphanede araştırma yapıyordum. Kütüphaneci beni gördü.',
        motive: 'Kurban, onun araştırmasını çaldığını iddia ediyordu ve akademik itibarını tehdit ediyordu.',
        isKiller: false,
        avatar: '👨‍🏫',
      ),
      Character(
        name: Translations.getText('housewife_name', language),
        role: Translations.getText('housewife_role', language),
        background: Translations.getText('housewife_background', language),
        personality: Translations.getText('housewife_personality', language),
        alibi: 'O akşam televizyon izliyordum. Komşular seslerimi duyabilir.',
        motive: 'Kurban, onun oğlunun işini kaybetmesine neden olmuştu.',
        isKiller: true,
        avatar: '👩‍🦱',
      ),
      Character(
        name: Translations.getText('guard_name', language),
        role: Translations.getText('guard_role', language),
        background: Translations.getText('guard_background', language),
        personality: Translations.getText('guard_personality', language),
        alibi: 'O akşam nöbetteydim. Giriş-çıkış kayıtlarım var.',
        motive: 'Kurban ona borç para vermişti ve geri ödemek istemiyordu.',
        isKiller: false,
        avatar: '👨‍💼',
      ),
    ];

    return GameState(
      storyTitle: Translations.getText('story_title', language),
      storyDescription: Translations.getText('story_description', language),
      crimeScene: 'Elif Özkan\'ın evi - 3. kat, 302 numara',
      victim: 'Elif Özkan - 45 yaşında, iş kadını',
      characters: characters,
    );
  }

  static List<String> getSuggestedQuestions([Language language = Language.turkish]) {
    return [
      Translations.getText('question_where_were_you', language),
      Translations.getText('question_relationship', language),
      Translations.getText('question_last_meeting', language),
      Translations.getText('question_enmity', language),
      Translations.getText('question_heard_anything', language),
      Translations.getText('question_benefit', language),
      Translations.getText('question_last_argument', language),
      Translations.getText('question_with_who', language),
      Translations.getText('question_debt', language),
      Translations.getText('question_who_could', language),
    ];
  }

  static String getGameInstructions([Language language = Language.turkish]) {
    return '''
${Translations.getText('game_objective', language)}:
${Translations.getText('game_objective_text', language)}

${Translations.getText('how_to_play', language)}:
${Translations.getText('how_to_play_1', language)}
${Translations.getText('how_to_play_2', language)}
${Translations.getText('how_to_play_3', language)}
${Translations.getText('how_to_play_4', language)}

${Translations.getText('clues', language)}:
${Translations.getText('clues_1', language)}
${Translations.getText('clues_2', language)}
${Translations.getText('clues_3', language)}
${Translations.getText('clues_4', language)}

${Translations.getText('question_suggestions', language)}:
${Translations.getText('question_1', language)}
${Translations.getText('question_2', language)}
${Translations.getText('question_3', language)}
''';
  }
}
