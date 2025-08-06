import 'package:catencyclopedia/domain/entities/cat_breed.dart';
import 'package:catencyclopedia/data/models/cat_breed_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:catencyclopedia/domain/repositories/cat_repository.dart';
import 'package:catencyclopedia/domain/usecases/get_breed_search.dart';
import 'package:catencyclopedia/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import 'get_breed_search_test.mocks.dart';

@GenerateMocks([CatRepository])
void main() {
  late GetBreedSearch useCase;
  late MockCatRepository mockRepository;

  setUp(() {
    mockRepository = MockCatRepository();
    useCase = GetBreedSearch(mockRepository);
  });

  final tBreeds = [
    CatBreed(
      id: 'beng',
      name: 'Bengal',
      url: 'https://bengal.jpg',
      origin: 'United States',
      temperament: 'Active, Energetic',
      description: 'Beautiful cat breed with wild appearance',
      weight: Weight(metric: '3-7 kg', imperial: '7-15 lbs'),
    ),
    CatBreed(
      id: 'siam',
      name: 'Siamese',
      url: 'https://siamese.jpg',
      origin: 'Thailand',
      temperament: 'Vocal, Social',
      description: 'Traditional Thai cat breed',
      weight: Weight(metric: '4-6 kg', imperial: '8-12 lbs'),
    ),
  ];

  group('GetBreedSearch', () {
    test('should return cat breeds matching the search query', () async {
      // arrange
      const query = 'Bengal';
      when(mockRepository.searchBreeds(query))
          .thenAnswer((_) async => Right(tBreeds));

      // act
      final result = await useCase(query);

      // assert
      expect(result, Right(tBreeds));
      verify(mockRepository.searchBreeds(query));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository call fails', () async {
      // arrange
      const query = 'Bengal';
      const errorMessage = 'Search failed';
      when(mockRepository.searchBreeds(query))
          .thenAnswer((_) async => Left(ServerFailure(message: errorMessage)));

      // act
      final result = await useCase(query);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (breeds) => fail('Should return failure'),
      );
      verify(mockRepository.searchBreeds(query));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no breeds match the query', () async {
      // arrange
      const query = 'NonExistentBreed';
      when(mockRepository.searchBreeds(query))
          .thenAnswer((_) async => const Right([]));

      // act
      final result = await useCase(query);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (breeds) => expect(breeds, isEmpty),
      );
      verify(mockRepository.searchBreeds(query));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle empty search query', () async {
      // arrange
      const query = '';
      when(mockRepository.searchBreeds(query))
          .thenAnswer((_) async => const Right([]));

      // act
      final result = await useCase(query);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (breeds) => expect(breeds, isEmpty),
      );
      verify(mockRepository.searchBreeds(query));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
