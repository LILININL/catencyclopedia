import 'package:dartz/dartz.dart';
import '../../entities/favorite_cat.dart';
import '../../repositories/favorite_repository.dart';

class GetFavoriteById {
  final FavoriteRepository repository;

  GetFavoriteById(this.repository);

  Future<Either<Exception, FavoriteCat?>> call(String catId) async {
    try {
      final result = await repository.getFavoriteById(catId);
      return result.fold(
        (failure) => Left(Exception(failure.toString())),
        (success) => Right(success),
      );
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
