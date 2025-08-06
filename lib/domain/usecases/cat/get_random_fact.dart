import 'package:catencyclopedia/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../repositories/cat_repository.dart';

class GetRandomFact {
  final CatRepository repository;

  GetRandomFact(this.repository);

  Future<Either<Failure, String>> call() => repository.getRandomFact();
}
