import '../../data/models/cat_image_model.dart';

class CatState {
  final List<CatImageModel>? images;
  final String? fact;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasReachedMax;
  final String? searchQuery;
  final String? breedIds; // เพิ่มตรงนี้

  CatState({
    this.images,
    this.fact,
    this.isLoading = false,
    this.error,
    this.currentPage = 0,
    this.hasReachedMax = false,
    this.searchQuery,
    this.breedIds, // เพิ่ม
  });

  CatState copyWith({
    List<CatImageModel>? images,
    String? fact,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasReachedMax,
    String? searchQuery,
    String? breedIds, // เพิ่ม
  }) {
    return CatState(
      images: images ?? this.images,
      fact: fact ?? this.fact,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchQuery: searchQuery ?? this.searchQuery,
      breedIds: breedIds ?? this.breedIds, // เพิ่ม
    );
  }
}
