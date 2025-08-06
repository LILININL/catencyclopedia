import '../../data/models/cat_breed_model.dart';

class CatState {
  final List<CatBreedModel>? images;
  final String? fact;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasReachedMax;
  final String? searchQuery;
  final String? breedIds;

  CatState({this.images, this.fact, this.isLoading = false, this.error, this.currentPage = 0, this.hasReachedMax = false, this.searchQuery, this.breedIds});

  CatState copyWith({List<CatBreedModel>? images, String? fact, bool? isLoading, String? error, int? currentPage, bool? hasReachedMax, String? searchQuery, String? breedIds}) {
    return CatState(
      images: images ?? this.images,
      fact: fact ?? this.fact,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchQuery: searchQuery ?? this.searchQuery,
      breedIds: breedIds ?? this.breedIds,
    );
  }
}
