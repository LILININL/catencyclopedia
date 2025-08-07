/// API และ Application Constants
class ApiConstants {
  // API Endpoints
  static const String baseUrl = 'https://api.thecatapi.com/v1';
  static const String imagesEndpoint = '/images/search';
  static const String breedsEndpoint = '/breeds/search';
  static const String factBaseUrl = 'https://catfact.ninja';
  static const String factEndpoint = '/fact';

  // API Parameters - Default Values
  static const int defaultPage = 0;
  static const int defaultLimit = 100;
  static const int maxLimit = 100;
  static const int minLimit = 1;

  // Image Parameters
  static const String imageSize = 'med';
  static const String mimeTypes = 'jpg';
  static const String format = 'json';
  static const bool hasBreeds = true;
  static const String order = 'RANDOM';

  // API Key (ในโปรเจค Production ควรเก็บใน Environment Variables)
  static const String apiKey = 'live_IYRCyeyGLPjd48Jgsk45Aak1mYnqT5LOAS0cAYBXR2iCIaEu0XNVxG3wfhEqgtY9';
}

/// UI Constants
class UIConstants {
  // Grid Layout
  static const int defaultGridColumns = 2;
  static const double cardElevation = 2.0;
  static const double borderRadius = 16.0;

  // Colors
  static const int catOrangeValue = 0xFFFFB74D;
  static const int catCreamValue = 0xFFFFF3E0;
  static const int catBrownValue = 0xFF8D5524;

  // Spacing
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
}

/// App Configuration
class AppConfig {
  // Timeouts
  static const int networkTimeoutSeconds = 30;
  static const int connectTimeoutSeconds = 10;

  // Cache
  static const int cacheMaxAge = 300; // 5 minutes

  // Pagination
  static const int loadMoreThreshold = 300; // pixels from bottom
}
