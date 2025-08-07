import 'package:catencyclopedia/core/error/failures.dart';
import 'package:dartz/dartz.dart';
// import '../../core/error/failures.dart';
import '../../entities/cat_breed.dart';
import '../../repositories/cat_repository.dart';

class GetBreedSearch {
  final CatRepository repository;

  GetBreedSearch(this.repository);

  Future<Either<Failure, List<CatBreed>>> call(String query) async {
    return await repository.searchBreeds(query);
  }
}
