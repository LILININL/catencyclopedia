import 'package:catencyclopedia/domain/repositories/favorite_repository.dart';
import 'package:dartz/dartz.dart';

class IsFavorite {
  final FavoriteRepository repository;

  IsFavorite(this.repository);

  Future<Either<Exception, bool>> call(String catId) async {
    try {
      final result = await repository.isFavorite(catId);
      return result.fold((failure) => Left(Exception(failure.toString())), (success) => Right(success));
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
