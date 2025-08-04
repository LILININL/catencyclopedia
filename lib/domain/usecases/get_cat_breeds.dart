import '../entities/cat_breed.dart';
import '../repositories/cat_repository.dart';

class GetCatBreeds {
  final CatRepository repository;
  GetCatBreeds(this.repository);

  Future<List<CatBreed>> call() => repository.getCatBreeds();
}
