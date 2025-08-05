import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:catencyclopedia/locator.dart';
import 'package:catencyclopedia/presentation/bloc/cat_bloc.dart';

import 'test_helper.mocks.dart';

@GenerateMocks([CatBloc])
void main() {}

MockCatBloc mockCatBloc() {
  final bloc = MockCatBloc();
  when(bloc.close()).thenAnswer((_) async => null);
  return bloc;
}
