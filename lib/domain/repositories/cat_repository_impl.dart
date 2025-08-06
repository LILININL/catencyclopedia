import 'package:catencyclopedia/core/error/failures.dart';
import 'package:catencyclopedia/data/models/cat_breed_model.dart';
import 'package:catencyclopedia/domain/entities/cat_breed.dart';
import 'package:dartz/dartz.dart';

import '../../data/sources/remote_data_source.dart';
import '../../domain/repositories/cat_repository.dart';

class CatRepositoryImpl implements CatRepository {
  final RemoteDataSource dataSource;

  CatRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<CatBreedModel>>> getCatImages({int page = 0, int limit = 20, String? breedIds}) async {
    try {
      final images = await dataSource.getCatImages(page: page, limit: limit, breedIds: breedIds);
      return Right(images);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getRandomFact() async {
    try {
      final fact = await dataSource.getRandomFact();
      return Right(fact);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CatBreed>>> searchBreeds(String query) async {
    try {
      final breedModels = await dataSource.searchBreeds(query);
      final breeds = List<CatBreed>.from(breedModels); 
      return Right(breeds);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
