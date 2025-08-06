import 'package:dartz/dartz.dart';
import '../../repositories/favorite_repository.dart';

class ClearFavorites {
  final FavoriteRepository repository;

  ClearFavorites(this.repository);

  Future<Either<Exception, Unit>> call() async {
    try {
      final result = await repository.clearFavorites();
      return result.fold(
        (failure) => Left(Exception(failure.toString())),
        (success) => Right(success),
      );
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
