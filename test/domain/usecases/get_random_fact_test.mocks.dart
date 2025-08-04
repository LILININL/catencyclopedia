import 'dart:async' as _i3;

import 'package:catencyclopedia/domain/entities/cat_breed.dart' as _i4;
import 'package:catencyclopedia/domain/repositories/cat_repository.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;

class MockCatRepository extends _i1.Mock implements _i2.CatRepository {
  MockCatRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.CatBreed>> getCatBreeds() =>
      (super.noSuchMethod(Invocation.method(#getCatBreeds, []), returnValue: _i3.Future<List<_i4.CatBreed>>.value(<_i4.CatBreed>[])) as _i3.Future<List<_i4.CatBreed>>);

  @override
  _i3.Future<String> getRandomFact() =>
      (super.noSuchMethod(Invocation.method(#getRandomFact, []), returnValue: _i3.Future<String>.value(_i5.dummyValue<String>(this, Invocation.method(#getRandomFact, [])))) as _i3.Future<String>);
}
