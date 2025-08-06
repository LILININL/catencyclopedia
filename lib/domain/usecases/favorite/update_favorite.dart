import 'package:dartz/dartz.dart';
import '../../entities/favorite_cat.dart';
import '../../repositories/favorite_repository.dart';

class UpdateFavorite {
  final FavoriteRepository repository;

  UpdateFavorite(this.repository);

  Future<Either<Exception, Unit>> call(FavoriteCat params) async {
    try {
      final result = await repository.updateFavorite(params);
      return result.fold((failure) => Left(Exception(failure.toString())), (success) => Right(success));
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
