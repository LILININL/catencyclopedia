import 'package:catencyclopedia/core/error/failures.dart';
import 'package:catencyclopedia/core/constants/app_constants.dart';
import 'package:dartz/dartz.dart';

import '../../../data/models/cat_breed_model.dart';
import '../../repositories/cat_repository.dart';

class GetCatImages {
  final CatRepository repository;

  GetCatImages(this.repository);

  Future<Either<Failure, List<CatBreedModel>>> call({int page = ApiConstants.defaultPage, int limit = ApiConstants.defaultLimit, String? breedIds}) async {
    return await repository.getCatImages(page: page, limit: limit, breedIds: breedIds);
  }
}
