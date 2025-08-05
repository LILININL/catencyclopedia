import 'package:catencyclopedia/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../data/models/cat_image_model.dart';
import '../repositories/cat_repository.dart';

class GetCatImages {
  final CatRepository repository;

  GetCatImages(this.repository);

  Future<Either<Failure, List<CatImageModel>>> call({int page = 0, int limit = 20, String? breedIds}) async {
    return await repository.getCatImages(page: page, limit: limit, breedIds: breedIds);
  }
}
