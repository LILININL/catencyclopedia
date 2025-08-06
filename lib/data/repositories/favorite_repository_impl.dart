import 'package:dartz/dartz.dart';
import '../../domain/entities/favorite_cat.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../models/favorite_cat_model.dart';
import '../sources/local/favorite_local_data_source.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteLocalDataSource localDataSource;

  FavoriteRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Exception, Unit>> addFavorite(FavoriteCat favoriteCat) async {
    try {
      final model = FavoriteCatModel.fromEntity(favoriteCat);
      await localDataSource.addFavorite(model);
      return const Right(unit);
    } catch (e) {
      return Left(Exception('Failed to add favorite: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, Unit>> updateFavorite(FavoriteCat favoriteCat) async {
    try {
      final model = FavoriteCatModel.fromEntity(favoriteCat);
      await localDataSource.updateFavorite(model);
      return const Right(unit);
    } catch (e) {
      return Left(Exception('Failed to update favorite: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, Unit>> removeFavorite(String catId) async {
    try {
      await localDataSource.removeFavorite(catId);
      return const Right(unit);
    } catch (e) {
      return Left(Exception('Failed to remove favorite: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, List<FavoriteCat>>> getFavorites() async {
    try {
      final models = await localDataSource.getFavorites();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(Exception('Failed to get favorites: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, bool>> isFavorite(String catId) async {
    try {
      final isFav = await localDataSource.isFavorite(catId);
      return Right(isFav);
    } catch (e) {
      return Left(Exception('Failed to check favorite: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, Unit>> clearFavorites() async {
    try {
      await localDataSource.clearFavorites();
      return const Right(unit);
    } catch (e) {
      return Left(Exception('Failed to clear favorites: ${e.toString()}'));
    }
  }
}
