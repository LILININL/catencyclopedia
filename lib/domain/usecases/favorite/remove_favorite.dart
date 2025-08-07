import 'package:catencyclopedia/domain/entities/favorite_cat.dart';
import 'package:catencyclopedia/domain/repositories/favorite_repository.dart';
import 'package:dartz/dartz.dart';

class RemoveFavorite {
  final FavoriteRepository repository;

  RemoveFavorite(this.repository);

  Future<Either<Exception, Unit>> call(String catId) async {
    try {
      final result = await repository.removeFavorite(catId);
      return result.fold((failure) => Left(Exception(failure.toString())), (success) => Right(success));
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
