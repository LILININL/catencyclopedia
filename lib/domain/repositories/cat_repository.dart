import '../entities/cat_breed.dart';

abstract class CatRepository {
  Future<List<CatBreed>> getCatBreeds();
  Future<String> getRandomFact();
}
