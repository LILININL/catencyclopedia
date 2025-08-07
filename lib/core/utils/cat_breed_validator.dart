/// Utility functions for validating and handling cat breed data
class CatBreedValidator {
  /// Validates if a breed name is valid
  static bool isValidBreedName(String? name) {
    if (name == null || name.trim().isEmpty) return false;
    return name.trim().length >= 2;
  }

  /// Validates if an image URL is valid
  static bool isValidImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Cleans and formats breed name
  static String formatBreedName(String? name) {
    if (name == null || name.trim().isEmpty) return 'Unknown Breed';
    return name.trim();
  }

  /// Validates favorite cat data
  static bool isValidFavoriteCat({
    required String? id,
    required String? imageUrl,
    required String? breedName,
  }) {
    return id != null && 
           id.trim().isNotEmpty && 
           isValidImageUrl(imageUrl) && 
           isValidBreedName(breedName);
  }
}
