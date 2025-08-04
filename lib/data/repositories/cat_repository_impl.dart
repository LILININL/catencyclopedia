import '../../domain/entities/cat_breed.dart';
import '../../domain/repositories/cat_repository.dart';
import '../sources/remote_data_source.dart';

class CatRepositoryImpl implements CatRepository {
  final RemoteDataSource dataSource;
  CatRepositoryImpl(this.dataSource);

  @override
  Future<List<CatBreed>> getCatBreeds() async {
    final models = await dataSource.getCatBreeds();
    return models;
  }

  @override
  Future<String> getRandomFact() => dataSource.getRandomFact();
}
