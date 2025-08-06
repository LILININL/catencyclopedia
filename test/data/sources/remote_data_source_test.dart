import 'package:catencyclopedia/data/models/cat_breed_model.dart';
import 'package:catencyclopedia/data/sources/remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late RemoteDataSource dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    // Mock the options property that RemoteDataSource uses
    when(mockDio.options).thenReturn(BaseOptions());
    dataSource = RemoteDataSource(mockDio);
  });

  group('RemoteDataSource', () {
    group('getCatImages', () {
      final tCatBreedModels = [
        CatBreedModel(
          id: 'test_1',
          url: 'https://test1.jpg',
          width: 500,
          height: 400,
          breeds: [Breed(id: 'beng', name: 'Bengal', origin: 'United States', temperament: 'Active, Energetic', description: 'Beautiful cat breed')],
        ),
      ];

      test('should return list of CatBreedModel when API call is successful', () async {
        // arrange
        final responseData = [
          {
            'id': 'test_1',
            'url': 'https://test1.jpg',
            'width': 500,
            'height': 400,
            'breeds': [
              {'id': 'beng', 'name': 'Bengal', 'origin': 'United States', 'temperament': 'Active, Energetic', 'description': 'Beautiful cat breed'},
            ],
          },
        ];

        when(mockDio.get(any, queryParameters: anyNamed('queryParameters'))).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // act
        final result = await dataSource.getCatImages();

        // assert
        expect(result, isA<List<CatBreedModel>>());
        expect(result.length, equals(1));
        expect(result.first.id, equals('test_1'));
        expect(result.first.breeds?.first.name, equals('Bengal'));
      });

      test('should return list with custom parameters', () async {
        // arrange
        const page = 1;
        const limit = 50;
        const breedIds = 'beng,siam';

        when(mockDio.get(any, queryParameters: anyNamed('queryParameters'))).thenAnswer(
          (_) async => Response(
            data: [],
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // act
        await dataSource.getCatImages(page: page, limit: limit, breedIds: breedIds);

        // assert
        verify(mockDio.get('https://api.thecatapi.com/v1/images/search', queryParameters: argThat(contains('page'), named: 'queryParameters')));
      });

      test('should throw Exception when API call fails', () async {
        // arrange
        when(mockDio.get(any, queryParameters: anyNamed('queryParameters'))).thenAnswer((_) async => Response(data: null, statusCode: 500, requestOptions: RequestOptions(path: '')));

        // act & assert
        expect(() => dataSource.getCatImages(), throwsA(isA<Exception>()));
      });

      test('should throw Exception when network error occurs', () async {
        // arrange
        when(mockDio.get(any, queryParameters: anyNamed('queryParameters'))).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Network error',
          ),
        );

        // act & assert
        expect(() => dataSource.getCatImages(), throwsA(isA<Exception>()));
      });
    });

    group('getRandomFact', () {
      test('should return string fact when API call is successful', () async {
        // arrange
        const tFact = 'Cats can jump up to 6 times their length.';
        final responseData = {'fact': tFact};

        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // act
        final result = await dataSource.getRandomFact();

        // assert
        expect(result, equals(tFact));
        verify(mockDio.get('https://catfact.ninja/fact'));
      });

      test('should throw Exception when API call fails', () async {
        // arrange
        when(mockDio.get(any)).thenAnswer((_) async => Response(data: null, statusCode: 404, requestOptions: RequestOptions(path: '')));

        // act & assert
        expect(() => dataSource.getRandomFact(), throwsA(isA<Exception>()));
      });
    });

    group('searchBreeds', () {
      test('should return list of CatBreedModel when search is successful', () async {
        // arrange
        const query = 'Bengal';
        final responseData = [
          {'id': 'beng', 'name': 'Bengal', 'origin': 'United States', 'temperament': 'Active, Energetic', 'description': 'Beautiful cat breed'},
        ];

        when(mockDio.get(any, queryParameters: anyNamed('queryParameters'))).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // act
        final result = await dataSource.searchBreeds(query);

        // assert
        expect(result, isA<List<CatBreedModel>>());
        verify(mockDio.get('https://api.thecatapi.com/v1/breeds/search', queryParameters: {'q': query}));
      });

      test('should throw Exception when search fails', () async {
        // arrange
        const query = 'InvalidBreed';
        when(mockDio.get(any, queryParameters: anyNamed('queryParameters'))).thenAnswer((_) async => Response(data: null, statusCode: 500, requestOptions: RequestOptions(path: '')));

        // act & assert
        expect(() => dataSource.searchBreeds(query), throwsA(isA<Exception>()));
      });
    });
  });
}
