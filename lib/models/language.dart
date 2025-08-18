enum Language {
  turkish('Türkçe', 'tr'),
  english('English', 'en');

  const Language(this.displayName, this.code);
  
  final String displayName;
  final String code;
  
  static Language fromCode(String code) {
    return Language.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => Language.turkish,
    );
  }
}
