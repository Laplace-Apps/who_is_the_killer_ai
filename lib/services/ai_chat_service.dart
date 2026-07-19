import '../models/character.dart';

abstract interface class CharacterChatService {
  Future<String> getCharacterResponse(
    Character character,
    String userMessage,
    String gameContext,
    String languageCode,
  );
}

/// Non-production responder used until Firebase AI Logic is available.
class LocalMockCharacterChatService implements CharacterChatService {
  const LocalMockCharacterChatService();

  @override
  Future<String> getCharacterResponse(
    Character character,
    String userMessage,
    String gameContext,
    String languageCode,
  ) async {
    return _getDynamicSimulatedResponse(character, userMessage);
  }

  String _getDynamicSimulatedResponse(Character character, String userMessage) {
    final message = userMessage.toLowerCase();
    final responses = _getCharacterResponses(character, message);

    if (responses.isNotEmpty) {
      final responseIndex = [
        ...character.name.codeUnits,
        ...message.codeUnits,
      ].fold<int>(0, (sum, value) => sum + value);
      return responses[responseIndex % responses.length];
    }

    return _getGeneralResponse(character, message);
  }

  List<String> _getCharacterResponses(Character character, String message) {
    if (character.name.contains('Prof. Dr. Ahmet Yılmaz')) {
      return _getProfessorResponses(character, message);
    } else if (character.name.contains('Ayşe Kaya')) {
      return _getHousewifeResponses(character, message);
    } else if (character.name.contains('Mehmet Demir')) {
      return _getSecurityGuardResponses(character, message);
    }

    return [];
  }

  List<String> _getProfessorResponses(Character character, String message) {
    if (character.isKiller) {
      if (message.contains('nerede') ||
          message.contains('neredeydin') ||
          message.contains('alibi')) {
        return [
          'Kütüphanede araştırma yapıyordum. Akademik çalışmalarım için gerekliydi.',
          'Üniversite kütüphanesindeydim. Yeni makalem için kaynak taraması yapıyordum.',
          'Kütüphanede çalışıyordum. Kütüphaneci beni gördü, kayıt defterinde imzam var.',
          'Araştırma odasındaydım. Müzik tarihi üzerine çalışıyordum.',
        ];
      } else if (message.contains('motif') ||
          message.contains('neden') ||
          message.contains('sebep')) {
        return [
          'Elif, benim araştırmamı çaldığını iddia ediyordu. Akademik itibarımı tehdit ediyordu.',
          'Elif\'in iddiaları beni çok üzdü. 20 yıllık kariyerimi lekeliyordu.',
          'Elif benim çalışmalarımı kendine mal etmeye çalışıyordu. Ama ben asla...',
          'Akademik hırsızlık iddiası beni derinden yaraladı. Ama şiddet çözüm değil.',
        ];
      } else if (message.contains('suçlu') ||
          message.contains('katil') ||
          message.contains('öldürdün')) {
        return [
          'Bu çok saçma! Ben bir akademisyenim, entelektüel biriyim.',
          'Şiddet benim karakterime tamamen aykırı. Ben araştırma yapan biriyim.',
          'Bu iddia beni çok üzdü. Ben sadece bilim yapmaya çalışıyorum.',
          'Akademik bir bakış açısıyla, şiddet hiçbir sorunu çözmez.',
        ];
      }
    } else {
      if (message.contains('nerede') ||
          message.contains('neredeydin') ||
          message.contains('alibi')) {
        return [
          'Kütüphanede araştırma yapıyordum. Müzik tarihi üzerine yeni bir makale hazırlıyordum.',
          'Üniversite kütüphanesindeydim. Kütüphaneci beni gördü, kayıt defterinde imzam var.',
          'Araştırma odasında çalışıyordum. Akademik çalışmalarım için gerekliydi.',
          'Kütüphanede kaynak taraması yapıyordum. Yeni projem için hazırlık yapıyordum.',
        ];
      } else if (message.contains('motif') ||
          message.contains('neden') ||
          message.contains('sebep')) {
        return [
          'Elif, benim araştırmamı çaldığını iddia ediyordu. Bu beni çok üzdü.',
          'Elif\'in iddiaları 20 yıllık akademik kariyerimi lekeliyordu.',
          'Akademik hırsızlık iddiası beni derinden yaraladı. Ama ben asla böyle bir şey yapmam!',
          'Elif benim çalışmalarımı kendine mal etmeye çalışıyordu. Bu beni çok üzdü.',
        ];
      } else if (message.contains('suçlu') ||
          message.contains('katil') ||
          message.contains('öldürdün')) {
        return [
          'Bu çok saçma! Ben bir akademisyenim, entelektüel biriyim.',
          'Şiddet benim karakterime tamamen aykırı. Gerçek katili bulmanız gerekiyor.',
          'Ben sadece bilim yapmaya çalışıyorum. Böyle bir şey yapmam.',
          'Akademik bir bakış açısıyla, şiddet hiçbir sorunu çözmez.',
        ];
      }
    }

    return [
      'Akademik bir bakış açısıyla, bu durumu analiz etmek gerekir.',
      'Detaylara önem veririm, bu yüzden kütüphanede araştırma yapıyordum.',
      'Bilimsel yöntemlerle bu sorunu çözmemiz gerekiyor.',
      'Akademik dürüstlük benim için çok önemli.',
    ];
  }

  List<String> _getHousewifeResponses(Character character, String message) {
    if (character.isKiller) {
      if (message.contains('nerede') ||
          message.contains('neredeydin') ||
          message.contains('alibi')) {
        return [
          'Evde televizyon izliyordum. O akşam favori dizim vardı.',
          'Evdeydim. Komşular seslerimi duyabilir... *gergin* Evet, kesinlikle evdeydim.',
          'Televizyon izliyordum. O akşam çok güzel bir dizi vardı.',
          'Evde dinleniyordum. Komşular beni gördü.',
        ];
      } else if (message.contains('motif') ||
          message.contains('neden') ||
          message.contains('sebep')) {
        return [
          'Elif, oğlumun işini kaybetmesine neden oldu! 3 aydır işsiz.',
          'Oğlum çok iyi bir çocuktu. Elif onun işini kaybetmesine neden oldu.',
          'Elif yüzünden oğlum işsiz kaldı. Ama ben... ben asla böyle bir şey yapmam!',
          'Oğlumun geleceğini mahvetti. Ama şiddet çözüm değil.',
        ];
      } else if (message.contains('suçlu') ||
          message.contains('katil') ||
          message.contains('öldürdün')) {
        return [
          'Ben mi? Bu çok saçma! Ben sadece bir ev hanımıyım.',
          '15 yıldır bu apartmanda yaşıyorum, herkes beni tanır.',
          'Ben sadece ev işleriyle uğraşan biriyim. Böyle şeyler yapmam.',
          'Bu iddia beni çok üzdü. Ben masumum!',
        ];
      }
    } else {
      if (message.contains('nerede') ||
          message.contains('neredeydin') ||
          message.contains('alibi')) {
        return [
          'Evde televizyon izliyordum. O akşam favori dizim vardı.',
          'Evdeydim. Komşular seslerimi duyabilir, tanıklarım var.',
          'Televizyon izliyordum. O akşam çok güzel bir dizi vardı.',
          'Evde dinleniyordum. Komşular beni gördü.',
        ];
      } else if (message.contains('motif') ||
          message.contains('neden') ||
          message.contains('sebep')) {
        return [
          'Elif, oğlumun işini kaybetmesine neden oldu! 3 aydır işsiz.',
          'Oğlum çok iyi bir çocuktu. Elif onun işini kaybetmesine neden oldu.',
          'Elif yüzünden oğlum işsiz kaldı. Bu beni çok üzdü ama şiddet çözüm değil.',
          'Oğlumun geleceğini mahvetti. Ama ben asla böyle bir şey yapmam!',
        ];
      } else if (message.contains('suçlu') ||
          message.contains('katil') ||
          message.contains('öldürdün')) {
        return [
          'Ben mi? Bu çok saçma! Ben sadece bir ev hanımıyım.',
          '15 yıldır bu apartmanda yaşıyorum, herkes beni tanır. Masumum!',
          'Ben sadece ev işleriyle uğraşan biriyim. Böyle şeyler yapmam.',
          'Bu iddia beni çok üzdü. Ben masumum!',
        ];
      }
    }

    return [
      'Ben sadece bir ev hanımıyım. Dedikoduları severim ama böyle korkunç şeyler yapmam.',
      'Gerçek katili bulmanız gerekiyor. Ben masumum.',
      'Bu apartmanda herkes beni tanır. Ben güvenilir biriyim.',
      'Ev işleriyle uğraşan biriyim. Böyle şeyler benim karakterime uygun değil.',
    ];
  }

  List<String> _getSecurityGuardResponses(Character character, String message) {
    if (character.isKiller) {
      if (message.contains('nerede') ||
          message.contains('neredeydin') ||
          message.contains('alibi')) {
        return [
          'Nöbetteydim. Giriş-çıkış kayıtlarım var.',
          '5 yıldır bu apartmanda çalışıyorum, güvenilir biriyim.',
          'Güvenlik noktasındaydım. Kayıt defterinde imzam var.',
          'Nöbet yerindeydim. Herkes beni gördü.',
        ];
      } else if (message.contains('motif') ||
          message.contains('neden') ||
          message.contains('sebep')) {
        return [
          'Elif bana borç para vermişti. Geri ödemek istemiyordu.',
          'Borç konusu beni üzdü. Ama ben... ben asla böyle bir şey yapmam.',
          'Para konusu vardı aramızda. Ama şiddet çözüm değil.',
          'Elif borçlu olduğunu kabul etmiyordu. Bu beni üzdü.',
        ];
      } else if (message.contains('suçlu') ||
          message.contains('katil') ||
          message.contains('öldürdün')) {
        return [
          'Bu çok saçma! Ben güvenlik görevlisiyim.',
          'Güvenlik sağlamak benim işim. Böyle bir şey yapmam.',
          '5 yıldır bu apartmanda çalışıyorum. Güvenilir biriyim.',
          'Ben sadece güvenlik sağlamaya çalışıyorum.',
        ];
      }
    } else {
      if (message.contains('nerede') ||
          message.contains('neredeydin') ||
          message.contains('alibi')) {
        return [
          'Nöbetteydim. Giriş-çıkış kayıtlarım var.',
          '5 yıldır bu apartmanda çalışıyorum, güvenilir biriyim.',
          'Güvenlik noktasındaydım. Kayıt defterinde imzam var.',
          'Nöbet yerindeydim. Herkes beni gördü.',
        ];
      } else if (message.contains('motif') ||
          message.contains('neden') ||
          message.contains('sebep')) {
        return [
          'Elif bana borç para vermişti. Geri ödemek istemiyordu.',
          'Borç konusu beni üzdü. Ama ben asla böyle bir şey yapmam!',
          'Para konusu vardı aramızda. Ama şiddet çözüm değil.',
          'Elif borçlu olduğunu kabul etmiyordu. Bu beni üzdü.',
        ];
      } else if (message.contains('suçlu') ||
          message.contains('katil') ||
          message.contains('öldürdün')) {
        return [
          'Bu çok saçma! Ben güvenlik görevlisiyim.',
          'Güvenlik sağlamak benim işim. Böyle bir şey yapmam. Masumum!',
          '5 yıldır bu apartmanda çalışıyorum. Güvenilir biriyim.',
          'Ben sadece güvenlik sağlamaya çalışıyorum.',
        ];
      }
    }

    return [
      'Ben güvenlik görevlisiyim. Sessiz ve gözlemci biriyim.',
      'Size yardım etmek istiyorum. Ne sormak istiyorsunuz?',
      'Güvenlik benim işim. Her şeyi gözlemlerim.',
      'Sessiz biriyim. Ama her şeyi görürüm.',
    ];
  }

  String _getGeneralResponse(Character character, String message) {
    if (message.contains('merhaba') || message.contains('selam')) {
      return 'Merhaba, ben ${character.name}. Size nasıl yardım edebilirim?';
    } else if (message.contains('kimsin') || message.contains('kim')) {
      return 'Ben ${character.name}, ${character.role}. ${character.background}';
    } else if (message.contains('kişilik') || message.contains('nasıl')) {
      return '${character.personality} Bu benim karakterim.';
    } else if (message.contains('yardım') || message.contains('bilgi')) {
      return 'Size yardım etmek istiyorum. Ne sormak istiyorsunuz?';
    } else {
      return 'Bu konuda yorum yapmak istemiyorum. Başka bir soru sorabilir misiniz?';
    }
  }
}
