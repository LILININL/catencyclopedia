import 'package:catencyclopedia/data/models/cat_breed_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:catencyclopedia/domain/repositories/cat_repository.dart';
import 'package:catencyclopedia/domain/usecases/get_cat_images.dart';
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
      id: 'test_1',
      url: 'https://test1.jpg',
      width: 500,
      height: 400,
      breeds: [
        Breed(
          id: 'beng',
          name: 'Bengal',
          origin: 'United States',
          temperament: 'Active, Energetic',
          description: 'Beautiful cat breed',
          weight: Weight(metric: '3-7 kg', imperial: '7-15 lbs'),
        ),
      ],
    ),
    CatBreedModel(
      id: 'test_2',
      url: 'https://test2.jpg',
      width: 600,
      height: 450,
      breeds: [
        Breed(
          id: 'siam',
          name: 'Siamese',
          origin: 'Thailand',
          temperament: 'Vocal, Social',
          description: 'Traditional Thai cat',
          weight: Weight(metric: '4-6 kg', imperial: '8-12 lbs'),
        ),
      ],
    ),
  ];

  group('GetCatImages', () {
    test('should get cat images from repository with default parameters', () async {
      // arrange
      when(mockRepository.getCatImages(page: 0, limit: 100, breedIds: null))
          .thenAnswer((_) async => Right(tImages));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(tImages));
      verify(mockRepository.getCatImages(page: 0, limit: 100, breedIds: null));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get cat images with custom parameters', () async {
      // arrange
      const page = 1;
      const limit = 10;
      const breedIds = 'beng,siam';
      
      when(mockRepository.getCatImages(page: page, limit: limit, breedIds: breedIds))
          .thenAnswer((_) async => Right(tImages));

      // act
      final result = await useCase(page: page, limit: limit, breedIds: breedIds);

      // assert
      expect(result, Right(tImages));
      verify(mockRepository.getCatImages(page: page, limit: limit, breedIds: breedIds));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository call fails', () async {
      // arrange
      const errorMessage = 'Network error occurred';
      when(mockRepository.getCatImages(page: 0, limit: 100, breedIds: null))
          .thenAnswer((_) async => Left(ServerFailure(message: errorMessage)));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(ServerFailure(message: errorMessage)));
      verify(mockRepository.getCatImages(page: 0, limit: 100, breedIds: null));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no images are found', () async {
      // arrange
      when(mockRepository.getCatImages(page: 0, limit: 100, breedIds: null))
          .thenAnswer((_) async => const Right([]));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right([]));
      verify(mockRepository.getCatImages(page: 0, limit: 100, breedIds: null));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
