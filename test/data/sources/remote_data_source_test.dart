import 'package:catencyclopedia/core/constants/app_constants.dart';
import 'package:catencyclopedia/data/models/cat_breed_model.dart';
import 'package:catencyclopedia/data/sources/remote/remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late RemoteCatDataSource dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    // Mock the options property that RemoteDataSource uses
    when(mockDio.options).thenReturn(BaseOptions());
    dataSource = RemoteCatDataSource(mockDio);
  });

  group('RemoteDataSource', () {
    group('getCatImages', () {
      final tCatBreedModels = [
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
            ),
          ],
        ),
      ];

      test('should return list of CatBreedModel when API call is successful', () async {
        // arrange
        final responseData = [
          {
            "id": "iWyIaja-G",
            "url": "https://cdn2.thecatapi.com/images/iWyIaja-G.jpg",
            "breeds": [
              {
                "weight": {"imperial": "6 - 12", "metric": "3 - 7"},
                "id": "beng",
                "name": "Bengal",
                "cfa_url": "http://cfa.org/Breeds/BreedsAB/Bengal.aspx",
                "vetstreet_url": "http://www.vetstreet.com/cats/bengal",
                "vcahospitals_url": "https://vcahospitals.com/know-your-pet/cat-breeds/bengal",
                "temperament": "Alert, Agile, Energetic, Demanding, Intelligent",
                "origin": "United States",
                "country_codes": "US",
                "country_code": "US",
                "description":
                    "Bengals are a lot of fun to live with, but they're definitely not the cat for everyone, or for first-time cat owners. Extremely intelligent, curious and active, they demand a lot of interaction and woe betide the owner who doesn't provide it.",
                "life_span": "12 - 15",
                "indoor": 0,
                "lap": 0,
                "adaptability": 5,
                "affection_level": 5,
                "child_friendly": 4,
                "cat_friendly": 4,
                "dog_friendly": 5,
                "energy_level": 5,
                "grooming": 1,
                "health_issues": 3,
                "intelligence": 5,
                "shedding_level": 3,
                "social_needs": 5,
                "stranger_friendly": 3,
                "vocalisation": 5,
                "bidability": 3,
                "experimental": 0,
                "hairless": 0,
                "natural": 0,
                "rare": 0,
                "rex": 0,
                "suppressed_tail": 0,
                "short_legs": 0,
                "wikipedia_url": "https://en.wikipedia.org/wiki/Bengal_(cat)",
                "hypoallergenic": 1,
                "reference_image_id": "O3btzLlsO",
              },
            ],
            "width": 1080,
            "height": 769,
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
        expect(result.first.id, equals('iWyIaja-G'));
        expect(result.first.breeds?.first.name, equals('Bengal'));
      });

      test('should return list with custom parameters', () async {
        // arrange
        const page = ApiConstants.defaultPage;
        const limit = ApiConstants.defaultLimit;
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
