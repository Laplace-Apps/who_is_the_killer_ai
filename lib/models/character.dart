class Character {
  final String id;
  final String name;
  final String role;
  final String background;
  final String personality;
  final String alibi;
  final String motive;
  final bool isKiller;
  final String avatar;
  final int colorValue;

  Character({
    required this.id,
    required this.name,
    required this.role,
    required this.background,
    required this.personality,
    required this.alibi,
    required this.motive,
    required this.isKiller,
    required this.avatar,
    this.colorValue = 0xFF4A6A7A,
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
      'id': id,
      'name': name,
      'role': role,
      'background': background,
      'personality': personality,
      'alibi': alibi,
      'motive': motive,
      'isKiller': isKiller,
      'avatar': avatar,
      'colorValue': colorValue,
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String? ?? json['name'] as String? ?? 'unknown',
      name: json['name'] as String,
      role: json['role'] as String,
      background: json['background'] as String,
      personality: json['personality'] as String,
      alibi: json['alibi'] as String,
      motive: json['motive'] as String? ?? '',
      isKiller: json['isKiller'] as bool? ?? false,
      avatar: json['avatar'] as String? ?? '👤',
      colorValue: json['colorValue'] as int? ?? 0xFF4A6A7A,
    );
  }
}
