import 'package:hive_flutter/hive_flutter.dart';
import 'package:translator/translator.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  late Box<String> _translationBox;
  final GoogleTranslator _translator = GoogleTranslator();
  bool _isInitialized = false;

  /// Initialize the translation service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _translationBox = await Hive.openBox<String>('translations');
      _isInitialized = true;
    } catch (e) {
      // If Hive fails, create a temporary in-memory storage
      print('Failed to initialize translation storage: $e');
      _isInitialized = false;
    }
  }

  /// Translate text to Thai with offline caching
  Future<String> translateToThai(String text) async {
    if (!_isInitialized) {
      return text; // Return original text if not initialized
    }

    if (text.trim().isEmpty) return text;

    // Create cache key
    final cacheKey = 'th_${text.toLowerCase().trim()}';

    // Check if translation exists in cache
    final cachedTranslation = _translationBox.get(cacheKey);
    if (cachedTranslation != null && cachedTranslation.isNotEmpty) {
      return cachedTranslation;
    }

    try {
      // Try to translate online
      final translation = await _translator.translate(text, from: 'en', to: 'th');

      final translatedText = translation.text;

      // Cache the translation
      await _translationBox.put(cacheKey, translatedText);

      return translatedText;
    } catch (e) {
      // If translation fails, return original text
      print('Translation failed: $e');
      return text;
    }
  }

  /// Get cached translation or return original text
  String getCachedTranslation(String text) {
    if (!_isInitialized) return text;

    final cacheKey = 'th_${text.toLowerCase().trim()}';
    return _translationBox.get(cacheKey) ?? text;
  }

  /// Pre-translate common cat breed terms
  Future<void> preloadCommonTranslations() async {
    if (!_isInitialized) return;

    final commonTerms = ['United States', 'United Kingdom', 'Thailand'];

    for (final term in commonTerms) {
      final cacheKey = 'th_${term.toLowerCase()}';
      if (_translationBox.get(cacheKey) == null) {
        try {
          await translateToThai(term);
          // Add small delay to avoid rate limiting
          await Future.delayed(const Duration(milliseconds: 100));
        } catch (e) {
          print('Failed to preload translation for: $term');
        }
      }
    }
  }

  /// Clear all cached translations
  Future<void> clearCache() async {
    if (_isInitialized) {
      await _translationBox.clear();
    }
  }

  /// Get cache size
  int get cacheSize => _isInitialized ? _translationBox.length : 0;

  /// Check if service is ready
  bool get isReady => _isInitialized;
}
