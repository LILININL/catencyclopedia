import 'package:catencyclopedia/domain/entities/favorite_cat.dart';
import 'package:catencyclopedia/domain/repositories/favorite_repository.dart';
import 'package:dartz/dartz.dart';

class GetFavorites {
  final FavoriteRepository repository;

  GetFavorites(this.repository);

  Future<Either<Exception, List<FavoriteCat>>> call() async {
    try {
      final result = await repository.getFavorites();
      return result.fold((failure) => Left(Exception(failure.toString())), (success) => Right(success));
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
