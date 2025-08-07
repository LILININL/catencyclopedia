import 'package:flutter_test/flutter_test.dart';
import 'package:catencyclopedia/core/utils/cat_breed_validator.dart';

void main() {
  group('CatBreedValidator', () {
    group('isValidBreedName', () {
      test('should return true for valid breed name', () {
        // Act & Assert
        expect(CatBreedValidator.isValidBreedName('Persian'), true);
        expect(CatBreedValidator.isValidBreedName('Bengal Cat'), true);
        expect(CatBreedValidator.isValidBreedName('Siamese'), true);
      });

      test('should return false for invalid breed name', () {
        // Act & Assert
        expect(CatBreedValidator.isValidBreedName(null), false);
        expect(CatBreedValidator.isValidBreedName(''), false);
        expect(CatBreedValidator.isValidBreedName('  '), false);
        expect(CatBreedValidator.isValidBreedName('A'), false);
      });
    });

    group('isValidImageUrl', () {
      test('should return true for valid URLs', () {
        // Act & Assert
        expect(CatBreedValidator.isValidImageUrl('https://example.com/image.jpg'), true);
        expect(CatBreedValidator.isValidImageUrl('http://example.com/cat.png'), true);
      });

      test('should return false for invalid URLs', () {
        // Act & Assert
        expect(CatBreedValidator.isValidImageUrl(null), false);
        expect(CatBreedValidator.isValidImageUrl(''), false);
        expect(CatBreedValidator.isValidImageUrl('not-a-url'), false);
        expect(CatBreedValidator.isValidImageUrl('ftp://example.com/image.jpg'), false);
      });
    });

    group('formatBreedName', () {
      test('should format breed name correctly', () {
        // Act & Assert
        expect(CatBreedValidator.formatBreedName('  Persian  '), 'Persian');
        expect(CatBreedValidator.formatBreedName('Bengal'), 'Bengal');
        expect(CatBreedValidator.formatBreedName(null), 'Unknown Breed');
        expect(CatBreedValidator.formatBreedName(''), 'Unknown Breed');
      });
    });

    group('isValidFavoriteCat', () {
      test('should return true for valid favorite cat data', () {
        // Act
        final result = CatBreedValidator.isValidFavoriteCat(
          id: 'cat123',
          imageUrl: 'https://example.com/cat.jpg',
          breedName: 'Persian',
        );

        // Assert
        expect(result, true);
      });

      test('should return false for invalid favorite cat data', () {
        // Act & Assert
        expect(
          CatBreedValidator.isValidFavoriteCat(
            id: null,
            imageUrl: 'https://example.com/cat.jpg',
            breedName: 'Persian',
          ),
          false,
        );

        expect(
          CatBreedValidator.isValidFavoriteCat(
            id: 'cat123',
            imageUrl: 'invalid-url',
            breedName: 'Persian',
          ),
          false,
        );

        expect(
          CatBreedValidator.isValidFavoriteCat(
            id: 'cat123',
            imageUrl: 'https://example.com/cat.jpg',
            breedName: null,
          ),
          false,
        );
      });
    });
  });
}
