class Term {
  final String word;
  final String generation;
  final String definition;
  final Map<String, String> translations;
  final String example;

  Term({
    required this.word,
    required this.generation,
    required this.definition,
    required this.translations,
    required this.example,
  });

  factory Term.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> translationsJson = json['translations'] ?? {};
    Map<String, String> translations = {};
    
    translationsJson.forEach((key, value) {
      translations[key] = value.toString();
    });

    return Term(
      word: json['word'] ?? '',
      generation: json['generation'] ?? '',
      definition: json['definition'] ?? '',
      translations: translations,
      example: json['example'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'generation': generation,
      'definition': definition,
      'translations': translations,
      'example': example,
    };
  }

  // Create a custom term with initial translations
  static Term createCustomTerm(
    String word,
    String generation,
    String definition,
    String example,
    Map<String, String> initialTranslations,
  ) {
    // Make sure all generations have a translation entry
    Map<String, String> translations = {
      'Boomers': '',
      'Gen X': '',
      'Millennials': '',
      'Gen Z': '',
      'Gen Alpha': '',
      ...initialTranslations,
    };
    
    // Remove the source generation's translation (since it's the original word)
    translations.remove(generation);
    
    return Term(
      word: word,
      generation: generation,
      definition: definition,
      translations: translations,
      example: example,
    );
  }
} 