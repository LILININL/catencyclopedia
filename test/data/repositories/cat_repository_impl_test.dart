import 'package:catencyclopedia/domain/repositories/cat_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:catencyclopedia/data/models/cat_image_model.dart';
import 'package:catencyclopedia/data/models/cat_breed_model.dart';
import 'package:catencyclopedia/data/repositories/cat_repository_impl.dart';
import 'package:catencyclopedia/data/sources/remote_data_source.dart';

import 'cat_repository_impl_test.mocks.dart';

@GenerateMocks([RemoteDataSource])
void main() {
  late CatRepositoryImpl repository;
  late MockRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockRemoteDataSource();
    repository = CatRepositoryImpl(mockDataSource);
  });

  final tImages = [
    CatImageModel(
      id: 'test',
      url: 'https://test.jpg',
      breeds: [CatBreedModel(id: 'beng', name: 'Bengal')],
    ),
  ];

  test('should get cat images from data source', () async {
    when(mockDataSource.getCatImages()).thenAnswer((_) async => tImages);
    final result = await repository.getCatImages();
    expect(result, tImages);
    verify(mockDataSource.getCatImages());
    verifyNoMoreInteractions(mockDataSource);
  });

  test('should get random fact from data source', () async {
    const tFact = 'Cats are cool';
    when(mockDataSource.getRandomFact()).thenAnswer((_) async => tFact);
    final result = await repository.getRandomFact();
    expect(result, tFact);
    verify(mockDataSource.getRandomFact());
    verifyNoMoreInteractions(mockDataSource);
  });
}
