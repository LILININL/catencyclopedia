import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart'; // Add this import

import 'get_random_fact_test.mocks.dart'; // Import same folder

import 'package:catencyclopedia/domain/repositories/cat_repository.dart'; // Package path to lib
import 'package:catencyclopedia/domain/usecases/cat/get_random_fact.dart';

@GenerateMocks([CatRepository]) // ต้องมีบรรทัดนี้เพื่อ trigger mockito gen!
void main() {
  late GetRandomFact useCase;
  late MockCatRepository mockRepository;

  setUp(() {
    mockRepository = MockCatRepository();
    useCase = GetRandomFact(mockRepository);
  });

  const tFact = 'Cats can jump up to 6 times their length.';

  test('should get random fact from the repository', () async {
    when(mockRepository.getRandomFact()).thenAnswer((_) async => Right(tFact));
    final result = await useCase();
    expect(result, Right(tFact));
    verify(mockRepository.getRandomFact());
    verifyNoMoreInteractions(mockRepository);
  });
}
