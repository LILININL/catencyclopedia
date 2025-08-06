import 'package:catencyclopedia/data/models/cat_breed_model.dart';
import 'package:catencyclopedia/data/sources/remote_data_source.dart';
import 'package:catencyclopedia/domain/repositories/cat_repository_impl.dart';
import 'package:catencyclopedia/domain/usecases/get_cat_images.dart';
import 'package:catencyclopedia/domain/usecases/get_random_fact.dart';
import 'package:catencyclopedia/domain/usecases/get_breed_search.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RemoteDataSource dataSource;
  late CatRepositoryImpl repository;
  late GetCatImages getCatImages;
  late GetRandomFact getRandomFact;
  late GetBreedSearch getBreedSearch;

  setUpAll(() {
    // สร้าง real dependencies สำหรับ integration test
    final dio = Dio();
    dataSource = RemoteDataSource(dio);
    repository = CatRepositoryImpl(dataSource);
    getCatImages = GetCatImages(repository);
    getRandomFact = GetRandomFact(repository);
    getBreedSearch = GetBreedSearch(repository);
  });

  group('Integration Tests - Real API Calls', () {
    group('GetCatImages UseCase', () {
      test('should fetch real cat images from API', () async {
        // act
        final result = await getCatImages(limit: 5);

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure: ${failure.message}'),
          (images) {
            expect(images, isA<List<CatBreedModel>>());
            expect(images.length, greaterThan(0));
            expect(images.length, lessThanOrEqualTo(5));
            
            // ตรวจสอบโครงสร้างข้อมูล
            final firstImage = images.first;
            expect(firstImage.id, isNotNull);
            expect(firstImage.url, isNotNull);
            expect(firstImage.url, startsWith('https://'));
            
            print('✅ Fetched ${images.length} cat images');
            print('📸 First image URL: ${firstImage.url}');
            if (firstImage.breeds?.isNotEmpty == true) {
              print('🐱 First breed: ${firstImage.breeds!.first.name}');
            }
          },
        );
      });

      test('should fetch images with specific breed ID', () async {
        // act - Bengal cats
        final result = await getCatImages(limit: 3, breedIds: 'beng');

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure: ${failure.message}'),
          (images) {
            expect(images, isA<List<CatBreedModel>>());
            print('✅ Fetched ${images.length} Bengal cat images');
          },
        );
      });
    });

    group('GetRandomFact UseCase', () {
      test('should fetch real cat fact from API', () async {
        // act
        final result = await getRandomFact();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure: ${failure.message}'),
          (fact) {
            expect(fact, isA<String>());
            expect(fact.length, greaterThan(10));
            print('✅ Fetched cat fact: $fact');
          },
        );
      });
    });

    group('GetBreedSearch UseCase', () {
      test('should search for Bengal breed', () async {
        // act
        final result = await getBreedSearch('Bengal');

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure: ${failure.message}'),
          (breeds) {
            expect(breeds.length, greaterThan(0));
            final bengalBreed = breeds.first;
            expect(bengalBreed.name.toLowerCase(), contains('bengal'));
            print('✅ Found ${breeds.length} breeds matching "Bengal"');
            print('🐱 First breed: ${bengalBreed.name} from ${bengalBreed.origin}');
          },
        );
      });

      test('should search for Siamese breed', () async {
        // act
        final result = await getBreedSearch('Siamese');

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure: ${failure.message}'),
          (breeds) {
            expect(breeds.length, greaterThan(0));
            final siameseBreed = breeds.first;
            expect(siameseBreed.name.toLowerCase(), contains('siamese'));
            print('✅ Found ${breeds.length} breeds matching "Siamese"');
            print('🐱 First breed: ${siameseBreed.name} from ${siameseBreed.origin}');
          },
        );
      });

      test('should handle search with no results', () async {
        // act
        final result = await getBreedSearch('NonExistentBreedXYZ123');

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure: ${failure.message}'),
          (breeds) {
            expect(breeds.length, equals(0));
            print('✅ No breeds found for non-existent search term');
          },
        );
      });
    });
  });

  group('Data Source Direct Tests', () {
    test('should fetch cat images directly from data source', () async {
      // act
      final images = await dataSource.getCatImages(limit: 3);

      // assert
      expect(images, isA<List<CatBreedModel>>());
      expect(images.length, greaterThan(0));
      expect(images.length, lessThanOrEqualTo(3));
      
      print('✅ Data source fetched ${images.length} images');
    });

    test('should fetch random fact directly from data source', () async {
      // act
      final fact = await dataSource.getRandomFact();

      // assert
      expect(fact, isA<String>());
      expect(fact.length, greaterThan(5));
      
      print('✅ Data source fetched fact: $fact');
    });

    test('should search breeds directly from data source', () async {
      // act
      final breeds = await dataSource.searchBreeds('Maine');

      // assert
      expect(breeds, isA<List<CatBreedModel>>());
      expect(breeds.length, greaterThan(0));
      
      print('✅ Data source found ${breeds.length} breeds for "Maine"');
    });
  });
}
