import 'package:dartz/dartz.dart';
import '../../entities/favorite_cat.dart';
import '../../repositories/favorite_repository.dart';

class AddFavoriteWithBreedDataParams {
  final FavoriteCat favoriteCat;
  final String? breedDescription;
  final String? origin;
  final String? temperament;
  final String? lifeSpan;
  final String? weight;
  final int? energyLevel;
  final int? sheddingLevel;
  final int? socialNeeds;
  final Map<String, dynamic>? additionalData;

  AddFavoriteWithBreedDataParams({
    required this.favoriteCat,
    this.breedDescription,
    this.origin,
    this.temperament,
    this.lifeSpan,
    this.weight,
    this.energyLevel,
    this.sheddingLevel,
    this.socialNeeds,
    this.additionalData,
  });
}

class AddFavoriteWithBreedData {
  final FavoriteRepository repository;

  AddFavoriteWithBreedData(this.repository);

  Future<Either<Exception, Unit>> call(AddFavoriteWithBreedDataParams params) async {
    try {
      final result = await repository.addFavoriteWithBreedData(
        params.favoriteCat,
        breedDescription: params.breedDescription,
        origin: params.origin,
        temperament: params.temperament,
        lifeSpan: params.lifeSpan,
        weight: params.weight,
        energyLevel: params.energyLevel,
        sheddingLevel: params.sheddingLevel,
        socialNeeds: params.socialNeeds,
        additionalData: params.additionalData,
      );
      return result.fold(
        (failure) => Left(Exception(failure.toString())),
        (success) => Right(success),
      );
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
