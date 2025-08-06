import 'package:catencyclopedia/data/models/cat_breed_model.dart';
import 'package:catencyclopedia/domain/repositories/cat_repository.dart';
import 'package:dartz/dartz.dart';

class SearchBreeds {
  final CatRepository repository;

  SearchBreeds(this.repository);

  Future<Either<Exception, List<CatBreedModel>>> call(String cat) async {
    try {
      final result = await repository.searchBreeds(cat);
      return result.fold((failure) => Left(Exception(failure.toString())), (success) => Right(success.cast<CatBreedModel>()));
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
