import '../repositories/cat_repository.dart';

class GetRandomFact {
  final CatRepository repository;

  GetRandomFact(this.repository);

  Future<String> call() => repository.getRandomFact();
}
