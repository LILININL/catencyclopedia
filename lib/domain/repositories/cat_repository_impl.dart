import 'package:catencyclopedia/core/error/failures.dart';
import 'package:catencyclopedia/data/models/cat_breed_model.dart';
import 'package:catencyclopedia/data/sources/local/local_data_source.dart';
import 'package:catencyclopedia/domain/entities/cat_breed.dart';
import 'package:catencyclopedia/core/constants/app_constants.dart';
import 'package:catencyclopedia/domain/entities/favorite_cat.dart';
import 'package:dartz/dartz.dart';

import '../../data/sources/remote/remote_data_source.dart';
import '../../domain/repositories/cat_repository.dart';

class CatRepositoryImpl implements CatRepository {
  final RemoteCatDataSource remoteCatDataSource;
  final LocalCatDataSource localCatDataSource;

  CatRepositoryImpl(this.remoteCatDataSource, this.localCatDataSource);

  @override
  Future<Either<Failure, List<CatBreedModel>>> getCatImages({int page = ApiConstants.defaultPage, int limit = ApiConstants.defaultLimit, String? breedIds}) async {
    try {
      final images = await remoteCatDataSource.getCatImages(page: page, limit: limit, breedIds: breedIds);
      return Right(images);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getRandomFact() async {
    try {
      final fact = await remoteCatDataSource.getRandomFact();
      return Right(fact);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CatBreed>>> searchBreeds(String catData) async {
    try {
      final breeds = await remoteCatDataSource.searchBreedsData(catData);

      final catBreeds = breeds.map((breed) => CatBreed.fromBreed(breed, '')).toList();
      return Right(catBreeds);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addFavorite(FavoriteCat favoriteCat) async {
    try {
      await localCatDataSource.addFavoriteCat(favoriteCat);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFavorite(String catId) async {
    try {
      await localCatDataSource.removeFavoriteCat(catId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FavoriteCat>>> getFavorites() async {
    try {
      final favorites = await localCatDataSource.getFavoriteCats();
      return Right(favorites);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String catId) async {
    try {
      final isFavorite = await localCatDataSource.isCatFavorite(catId);
      return Right(isFavorite);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearFavorites() async {
    try {
      await localCatDataSource.clearFavorites();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateFavorite(FavoriteCat favoriteCat) async {
    try {
      await localCatDataSource.updateFavoriteCat(favoriteCat);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
