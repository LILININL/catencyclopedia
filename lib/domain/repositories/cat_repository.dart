import 'package:catencyclopedia/core/error/failures.dart';
import 'package:catencyclopedia/domain/entities/cat_breed.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/cat_breed_model.dart';

abstract class CatRepository {
  Future<Either<Failure, List<CatBreedModel>>> getCatImages({int page = 0, int limit = 100, String? breedIds});
  Future<Either<Failure, String>> getRandomFact();
  Future<Either<Failure, List<CatBreed>>> searchBreeds(String query);
}
