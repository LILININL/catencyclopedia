import 'package:catencyclopedia/domain/entities/cat_breed.dart';

class CatState {
  final List<CatBreed>? breeds;
  final String? fact;
  final bool isLoading;
  final String? error;

  CatState({this.breeds, this.fact, this.isLoading = false, this.error});
}
