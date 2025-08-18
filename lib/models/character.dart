class Character {
  final String name;
  final String role;
  final String background;
  final String personality;
  final String alibi;
  final String motive;
  final bool isKiller;
  final String avatar;

  Character({
    required this.name,
    required this.role,
    required this.background,
    required this.personality,
    required this.alibi,
    required this.motive,
    required this.isKiller,
    required this.avatar,
  });

  String get fullDescription {
    return '''
Karakter: $name
Rol: $role
Arka Plan: $background
Kişilik: $personality
Mazeret: $alibi
Motif: $motive
''';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'background': background,
      'personality': personality,
      'alibi': alibi,
      'motive': motive,
      'isKiller': isKiller,
      'avatar': avatar,
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'],
      role: json['role'],
      background: json['background'],
      personality: json['personality'],
      alibi: json['alibi'],
      motive: json['motive'],
      isKiller: json['isKiller'],
      avatar: json['avatar'],
    );
  }
}
