import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:age_lingo/models/term.dart';

class TranslationResult {
  final String translatedText;
  final List<TranslatedWord> words;
  final String fromGeneration;
  final String toGeneration;
  final int translatedCount;
  
  TranslationResult({
    required this.translatedText,
    required this.words,
    required this.fromGeneration,
    required this.toGeneration,
    required this.translatedCount,
  });
}

class TranslatedWord {
  final String original;
  final String translated;
  final bool wasTranslated;
  final Term? term; // The term used for translation, if any
  
  TranslatedWord({
    required this.original,
    required this.translated,
    required this.wasTranslated,
    this.term,
  });
}

class TermService extends ChangeNotifier {
  List<Term> _terms = [];
  List<Term> _customTerms = [];
  static final TermService _instance = TermService._internal();

  factory TermService() => _instance;

  TermService._internal();

  Future<void> loadTerms() async {
    try {
      // Optimize loading by checking if terms are already loaded
      if (_terms.isNotEmpty) {
        return;
      }

      // Load built-in terms from JSON file
      final String response = await rootBundle.loadString('assets/data/terms.json');
      final data = json.decode(response);
      
      // Process terms in chunks to prevent UI freezing
      await _processTermsInChunks(data['terms']);
      
      // Load custom terms from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final String? customTermsJson = prefs.getString('custom_terms');
      
      if (customTermsJson != null) {
        final List<dynamic> customTermsData = json.decode(customTermsJson);
        _customTerms = customTermsData.map((data) => Term.fromJson(data)).toList();
      }
      
      _terms = [..._terms, ..._customTerms];
      notifyListeners();
    } catch (e) {
      print('Error loading terms: $e');
      // Initialize with empty lists if loading fails
      _terms = [];
      _customTerms = [];
      notifyListeners();
    }
  }
  
  // Process terms in chunks to prevent UI freezing
  Future<void> _processTermsInChunks(List<dynamic> termsData) async {
    const int chunkSize = 50; // Process 50 terms at a time
    
    for (int i = 0; i < termsData.length; i += chunkSize) {
      final int end = (i + chunkSize < termsData.length) ? i + chunkSize : termsData.length;
      final chunk = termsData.sublist(i, end);
      
      _terms.addAll(chunk.map((data) => Term.fromJson(data)).toList());
      
      // Allow UI to update between chunks
      await Future.delayed(const Duration(milliseconds: 1));
    }
    
    // Sort terms alphabetically for better user experience
    _terms.sort((a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase()));
  }
  
  Future<void> _saveCustomTerms() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedTerms = json.encode(_customTerms.map((term) => term.toJson()).toList());
    await prefs.setString('custom_terms', encodedTerms);
  }
  
  // Add a new custom term
  Future<bool> addCustomTerm(Term term) async {
    // Check if this term already exists
    if (_terms.any((t) => t.word.toLowerCase() == term.word.toLowerCase() && t.generation == term.generation) ||
        _customTerms.any((t) => t.word.toLowerCase() == term.word.toLowerCase() && t.generation == term.generation)) {
      return false; // Term already exists
    }
    
    _customTerms.add(term);
    await _saveCustomTerms();
    return true;
  }
  
  // Edit existing custom term
  Future<bool> editCustomTerm(String originalWord, String originalGeneration, Term updatedTerm) async {
    final index = _customTerms.indexWhere(
      (t) => t.word.toLowerCase() == originalWord.toLowerCase() && t.generation == originalGeneration
    );
    
    if (index == -1) {
      return false; // Term not found
    }
    
    _customTerms[index] = updatedTerm;
    await _saveCustomTerms();
    return true;
  }
  
  // Delete custom term
  Future<bool> deleteCustomTerm(String word, String generation) async {
    final index = _customTerms.indexWhere(
      (t) => t.word.toLowerCase() == word.toLowerCase() && t.generation == generation
    );
    
    if (index == -1) {
      return false; // Term not found
    }
    
    _customTerms.removeAt(index);
    await _saveCustomTerms();
    return true;
  }
  
  // Get all custom terms
  List<Term> getCustomTerms() {
    return _customTerms;
  }

  List<Term> getAllTerms() {
    return [..._terms, ..._customTerms];
  }

  List<Term> getTermsByGeneration(String generation) {
    return getAllTerms().where((term) => term.generation == generation).toList();
  }

  List<Term> searchTerms(String query) {
    if (query.isEmpty) return [];
    
    query = query.toLowerCase();
    return getAllTerms().where((term) => 
      term.word.toLowerCase().contains(query) ||
      term.definition.toLowerCase().contains(query) ||
      term.example.toLowerCase().contains(query)
    ).toList();
  }

  // Find a term by exact match or similar words (handles plurals, tenses)
  Term? _findTermForWord(String word, String generation) {
    word = word.toLowerCase();
    
    // Search in both built-in and custom terms
    List<Term> allTerms = getAllTerms();
    
    // First try exact match
    try {
      Term exactMatch = allTerms.firstWhere(
        (t) => t.word.toLowerCase() == word && t.generation == generation,
      );
      return exactMatch;
    } catch (e) {
      // No exact match found
    }
    
    // Try to match words with different endings (plurals, -ing, -ed, etc.)
    String wordRoot = _getRootWord(word);
    if (wordRoot.length > 2) { // Only check roots that are substantial
      try {
        return allTerms.firstWhere((t) {
          String termRoot = _getRootWord(t.word.toLowerCase());
          return termRoot == wordRoot && t.generation == generation;
        });
      } catch (e) {
        // No root match found
      }
    }
    
    // Try partial match for phrases (e.g., "no cap" should match "cap")
    try {
      return allTerms.firstWhere((t) {
        return t.generation == generation &&
          (word.contains(t.word.toLowerCase()) || t.word.toLowerCase().contains(word));
      });
    } catch (e) {
      // No partial match
      return null;
    }
  }
  
  // Helper to get the "root" of a word by removing common endings
  String _getRootWord(String word) {
    if (word.endsWith('ing')) return word.substring(0, word.length - 3);
    if (word.endsWith('ed')) return word.substring(0, word.length - 2);
    if (word.endsWith('s')) return word.substring(0, word.length - 1);
    if (word.endsWith('er')) return word.substring(0, word.length - 2);
    return word;
  }

  // Enhanced translate method that returns a TranslationResult
  TranslationResult translateEnhanced(String text, String fromGeneration, String toGeneration) {
    if (text.isEmpty) {
      return TranslationResult(
        translatedText: '', 
        words: [], 
        fromGeneration: fromGeneration, 
        toGeneration: toGeneration, 
        translatedCount: 0
      );
    }
    
    // If translating to the same generation, just return the original text
    if (fromGeneration == toGeneration) {
      List<TranslatedWord> words = text.split(' ').map((word) => 
        TranslatedWord(
          original: word,
          translated: word,
          wasTranslated: false,
        )
      ).toList();
      
      return TranslationResult(
        translatedText: text,
        words: words,
        fromGeneration: fromGeneration,
        toGeneration: toGeneration,
        translatedCount: 0,
      );
    }
    
    // Keep track of which words were translated
    int translatedCount = 0;
    List<TranslatedWord> translatedWords = [];
    
    // First check for multi-word phrases (like "no cap")
    // We'll replace them with placeholders to preserve them during word-by-word translation
    String workingText = text;
    
    // Check for phrases first (multi-word terms)
    List<Term> multiWordTerms = getAllTerms().where((t) {
      return t.generation == fromGeneration && t.word.contains(' ');
    }).toList();
    
    // Sort by length descending so longer phrases are matched first
    multiWordTerms.sort((a, b) => b.word.length.compareTo(a.word.length));
    
    // Process multi-word terms
    for (var term in multiWordTerms) {
      final wordPattern = RegExp('\\b${RegExp.escape(term.word)}\\b', caseSensitive: false);
      
      if (wordPattern.hasMatch(workingText.toLowerCase())) {
        final matches = wordPattern.allMatches(workingText.toLowerCase());
        int offsetAdjustment = 0;
        
        for (final match in matches) {
          final startPos = match.start + offsetAdjustment;
          final endPos = match.end + offsetAdjustment;
          final originalPhrase = workingText.substring(startPos, endPos);
          final translatedPhrase = term.translations[toGeneration] ?? originalPhrase;
          
          // Create a translated word object for this phrase
          final translatedWord = TranslatedWord(
            original: originalPhrase,
            translated: translatedPhrase,
            wasTranslated: true,
            term: term,
          );
          
          // Add to the translated words list
          translatedWords.add(translatedWord);
          
          // Replace the original phrase with a placeholder
          final placeholder = '__TRANSLATED_PHRASE_${translatedWords.length - 1}__';
          workingText = workingText.substring(0, startPos) + 
                         placeholder + 
                         workingText.substring(endPos);
          
          // Adjust offset for next replacements
          offsetAdjustment += placeholder.length - originalPhrase.length;
          translatedCount++;
        }
      }
    }
    
    // Process the remaining text word by word
    List<String> words = workingText.split(' ');
    List<TranslatedWord> processedWords = [];
    
    for (var word in words) {
      // Check if this is a placeholder for an already-translated phrase
      if (word.startsWith('__TRANSLATED_PHRASE_')) {
        try {
          // This is a placeholder for a phrase we already translated
          String indexStr = word.replaceAll('__TRANSLATED_PHRASE_', '').replaceAll('__', '');
          int index = int.parse(indexStr);
          processedWords.add(translatedWords[index]);
        } catch (e) {
          // If there's an error parsing the placeholder, just add the original word
          processedWords.add(TranslatedWord(
            original: word,
            translated: word,
            wasTranslated: false,
          ));
        }
        continue;
      }
      
      // Extract punctuation
      String punctuation = '';
      String cleanWord = word;
      
      // Check for punctuation at the end
      if (RegExp(r'[.,!?;:")\]]$').hasMatch(cleanWord)) {
        punctuation = cleanWord[cleanWord.length - 1];
        cleanWord = cleanWord.substring(0, cleanWord.length - 1);
      }
      
      // Check for punctuation at the start
      String startPunctuation = '';
      if (RegExp(r'^[.,!?;:"(\[]').hasMatch(cleanWord)) {
        startPunctuation = cleanWord[0];
        cleanWord = cleanWord.substring(1);
      }
      
      // Skip empty words
      if (cleanWord.isEmpty) {
        processedWords.add(TranslatedWord(
          original: word,
          translated: word,
          wasTranslated: false,
        ));
        continue;
      }
      
      // Try to find a term for this word
      Term? term = _findTermForWord(cleanWord, fromGeneration);
      
      if (term != null && term.translations.containsKey(toGeneration) && 
          term.translations[toGeneration] != null && 
          term.translations[toGeneration]!.isNotEmpty) {
        
        // We found a match! Translate the word
        final translatedWord = term.translations[toGeneration]!;
        
        processedWords.add(TranslatedWord(
          original: startPunctuation + cleanWord + punctuation,
          translated: startPunctuation + translatedWord + punctuation,
          wasTranslated: true,
          term: term,
        ));
        translatedCount++;
      } else {
        // No translation found, keep the original
        processedWords.add(TranslatedWord(
          original: word,
          translated: word,
          wasTranslated: false,
        ));
      }
    }
    
    // Build the translated text
    String translatedText = processedWords.map((w) => w.translated).join(' ');
    
    return TranslationResult(
      translatedText: translatedText,
      words: processedWords,
      fromGeneration: fromGeneration,
      toGeneration: toGeneration,
      translatedCount: translatedCount,
    );
  }

  // Keep the original translate method for backward compatibility
  String translate(String text, String fromGeneration, String toGeneration) {
    TranslationResult result = translateEnhanced(text, fromGeneration, toGeneration);
    return result.translatedText;
  }
} 