import '../models/character.dart';
import '../models/game_state.dart';
import '../models/language.dart';

/// Helpers for suggested questions and sync test fixtures.
/// Runtime games should use [CaseContentRepository] via [GameProvider.startNewGame].
class GameData {
  static GameState createNewGame([Language language = Language.turkish]) {
    final isTr = language == Language.turkish;
    final characters = [
      Character(
        id: 'suspect_01',
        name: 'Dr. Elena Vance',
        role: isTr ? 'Kıdemli Astrofizikçi' : 'Lead Astrophysicist',
        background: isTr
            ? 'On beş yıllık iş arkadaşı.'
            : 'Fifteen-year collaborator.',
        personality: isTr ? 'Klinik' : 'Clinical',
        alibi: isTr ? 'Yemekhane / odası' : 'Mess Hall / quarters',
        motive: '',
        isKiller: false,
        avatar: '👩‍🔬',
        colorValue: 0xFFC45C26,
      ),
      Character(
        id: 'suspect_02',
        name: 'Marcus Thorne',
        role: isTr ? 'Kurbanın oğlu' : "Victim's son",
        background: isTr ? 'Davetsiz misafir.' : 'Uninvited guest.',
        personality: isTr ? 'Düşmanca' : 'Hostile',
        alibi: isTr ? 'Batı Kanadı' : 'West Wing',
        motive: '',
        isKiller: false,
        avatar: '🧑',
        colorValue: 0xFF6B4C9A,
      ),
      Character(
        id: 'suspect_03',
        name: 'Suna Aksoy',
        role: isTr ? 'Araştırmacı' : 'Researcher',
        background: isTr ? 'Protégé.' : 'Protégé.',
        personality: isTr ? 'Kaygılı' : 'Anxious',
        alibi: isTr ? 'Doğu Kanadı' : 'East Wing',
        motive: '',
        isKiller: false,
        avatar: '👩‍💻',
        colorValue: 0xFF2A7A8A,
      ),
      Character(
        id: 'suspect_04',
        name: 'Julian Vane',
        role: 'CEO',
        background: isTr ? 'Bağışçı.' : 'Benefactor.',
        personality: isTr ? 'Cilalı' : 'Polished',
        alibi: isTr ? 'Batı Kanadı süit' : 'West Wing suite',
        motive: '',
        isKiller: false,
        avatar: '🧔',
        colorValue: 0xFF8A7A2A,
      ),
      Character(
        id: 'suspect_05',
        name: 'Captain Silas Reed',
        role: isTr ? 'Güvenlik' : 'Security',
        background: isTr ? 'Güvenlik şefi.' : 'Security chief.',
        personality: isTr ? 'Disiplinli' : 'Disciplined',
        alibi: isTr ? 'İzleme istasyonu' : 'Monitoring station',
        motive: '',
        isKiller: false,
        avatar: '👮',
        colorValue: 0xFF3A5A3A,
      ),
      Character(
        id: 'suspect_06',
        name: 'Dr. Hugo Sterling',
        role: isTr ? 'Emekli gökbilimci' : 'Retired astronomer',
        background: isTr ? 'Eski müdür.' : 'Former director.',
        personality: isTr ? 'Nazik' : 'Gentle',
        alibi: isTr ? 'Batı Kanadı' : 'West Wing',
        motive: '',
        isKiller: false,
        avatar: '🧓',
        colorValue: 0xFF7A6A5A,
      ),
    ];

    return GameState(
      storyTitle: isTr ? 'Fısıltı Gözlemevi' : 'The Whispering Observatory',
      storyDescription: isTr
          ? 'Andean Peaks Gözlemevi\'nde kilitli kubbe cinayeti.'
          : 'A locked-dome murder at Andean Peaks Observatory.',
      crimeScene: 'Andean Peaks Observatory',
      victim: 'Dr. Alistair Thorne',
      characters: characters,
    );
  }

  static List<String> getSuggestedQuestions([
    Language language = Language.turkish,
  ]) {
    if (language == Language.turkish) {
      return const [
        'Saat 23:00\'te neredeydiniz?',
        'Alistair ile ilişkiniz nasıldı?',
        'Güç kesintisi sırasında neredeydiniz?',
        'Ana anahtar hakkında ne biliyorsunuz?',
        'Kubbe kapısı nasıl kilitlendi?',
        'Kimden şüpheleniyorsunuz?',
      ];
    }
    return const [
      'Where were you at 11:00 PM?',
      'What was your relationship with Alistair?',
      'Where were you during the power flicker?',
      'What do you know about the master key?',
      'How was the dome door locked?',
      'Who do you suspect?',
    ];
  }

  static String getGameInstructions([Language language = Language.turkish]) {
    if (language == Language.turkish) {
      return 'Odaları gezin, şüphelilerle konuşun, kanıt toplayın ve suçlayın.';
    }
    return 'Explore rooms, talk to suspects, collect clues, and accuse.';
  }
}
