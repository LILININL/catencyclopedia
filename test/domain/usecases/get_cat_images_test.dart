import 'package:catencyclopedia/core/constants/app_constants.dart';
import 'package:catencyclopedia/data/models/cat_breed_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:catencyclopedia/domain/repositories/cat_repository.dart';
import 'package:catencyclopedia/domain/usecases/cat/get_cat_images.dart';
import 'package:catencyclopedia/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import 'get_cat_images_test.mocks.dart';

@GenerateMocks([CatRepository])
void main() {
  late GetCatImages useCase;
  late MockCatRepository mockRepository;

  setUp(() {
    mockRepository = MockCatRepository();
    useCase = GetCatImages(mockRepository);
  });

  final tImages = [
    CatBreedModel(
      id: 'iWyIaja-G',
      url: 'https://cdn2.thecatapi.com/images/iWyIaja-G.jpg',
      width: 1080,
      height: 769,
      breeds: [
        Breed(
          id: 'beng',
          name: 'Bengal',
          origin: 'United States',
          temperament: 'Alert, Agile, Energetic, Demanding, Intelligent',
          description:
              'Bengals are a lot of fun to live with, but they\'re definitely not the cat for everyone, or for first-time cat owners. Extremely intelligent, curious and active, they demand a lot of interaction and woe betide the owner who doesn\'t provide it.',
          weight: Weight(metric: '3 - 7', imperial: '6 - 12'),
        ),
      ],
    ),
    CatBreedModel(
      id: 'test_2',
      url: 'https://cdn2.thecatapi.com/images/test_2.jpg',
      width: 800,
      height: 600,
      breeds: [
        Breed(
          id: 'siam',
          name: 'Siamese',
          origin: 'Thailand',
          temperament: 'Active, Agile, Clever, Sociable, Loving, Vocal',
          description: 'The Siamese cat is one of the first distinctly recognized breeds of Asian cat. Derived from the Wichianmat landrace, one of several varieties of cat native to Thailand.',
          weight: Weight(metric: '4 - 6', imperial: '8 - 12'),
        ),
      ],
    ),
  ];

  group('GetCatImages', () {
    test('should get cat images from repository with default parameters', () async {
      // arrange
      when(mockRepository.getCatImages(page: 0, limit: 100, breedIds: null)).thenAnswer((_) async => Right(tImages));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(tImages));
      verify(mockRepository.getCatImages(page: 0, limit: 100, breedIds: null));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get cat images with custom parameters', () async {
      // arrange
      const page = ApiConstants.defaultPage;
      const limit = ApiConstants.defaultLimit;
      const breedIds = 'beng,siam';

      when(mockRepository.getCatImages(page: page, limit: limit, breedIds: breedIds)).thenAnswer((_) async => Right(tImages));

      // act
      final result = await useCase(page: page, limit: limit, breedIds: breedIds);

      // assert
      expect(result, Right(tImages));
      verify(mockRepository.getCatImages(page: page, limit: limit, breedIds: breedIds));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
