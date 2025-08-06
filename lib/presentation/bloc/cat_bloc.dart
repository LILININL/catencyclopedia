import 'package:bloc/bloc.dart';
import 'package:catencyclopedia/domain/usecases/get_breed_search.dart';
import '../../domain/usecases/get_cat_images.dart';
import '../../domain/usecases/get_random_fact.dart';
import 'cat_event.dart';
import 'cat_state.dart';

class CatBloc extends Bloc<CatEvent, CatState> {
  final GetCatImages getImages;
  final GetRandomFact getFact;
  final GetBreedSearch getBreedSearch;

  CatBloc({required this.getImages, required this.getFact, required this.getBreedSearch}) : super(CatState()) {
    on<LoadImages>(_onLoadImages);
    on<GetFact>(_onGetFact);
    on<RefreshImages>(_onRefreshImages);
    on<SearchBreeds>(_onSearchBreeds);
    on<LoadMoreImages>(_onLoadMoreImages);
  }

  Future<void> _onSearchBreeds(SearchBreeds event, Emitter<CatState> emit) async {
    if (event.query.isEmpty) {
      add(LoadImages());
      return;
    }
    emit(state.copyWith(isLoading: true, error: null, images: [], currentPage: 0, hasReachedMax: false, searchQuery: event.query, breedIds: null));
    final result = await getBreedSearch.call(event.query);
    result.fold((failure) => emit(state.copyWith(error: failure.message ?? 'Search failed', isLoading: false)), (breedsResult) async {
      if (breedsResult.isEmpty) {
        emit(state.copyWith(isLoading: false, hasReachedMax: true));
        return;
      }
      final breedIds = breedsResult.map((b) => b.id).join(',');
      final imagesResult = await getImages.call(page: 0, breedIds: breedIds);
      imagesResult.fold((failure) => emit(state.copyWith(error: failure.message ?? 'Load images failed', isLoading: false)), (images) {
        emit(state.copyWith(images: images, isLoading: false, hasReachedMax: images.length < 100, breedIds: breedIds));
      });
    });
  }

  Future<void> _onLoadMoreImages(LoadMoreImages event, Emitter<CatState> emit) async {
    if (state.hasReachedMax || state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    final nextPage = state.currentPage + 1;
    final imagesResult = await getImages.call(page: nextPage, breedIds: state.breedIds);
    imagesResult.fold((failure) => emit(state.copyWith(error: failure.message ?? 'Load more failed', isLoading: false)), (images) {
      if (images.isEmpty) {
        emit(state.copyWith(hasReachedMax: true, isLoading: false));
      } else {
        emit(state.copyWith(images: [...?state.images, ...images], currentPage: nextPage, hasReachedMax: images.length < 20, isLoading: false));
      }
    });
  }

  Future<void> _onLoadImages(LoadImages event, Emitter<CatState> emit) async {
    emit(state.copyWith(isLoading: true, error: null, images: [], currentPage: 0, hasReachedMax: false, searchQuery: null, breedIds: null));
    final imagesResult = await getImages.call(page: 0);
    imagesResult.fold((failure) => emit(state.copyWith(error: failure.message ?? 'Load images failed', isLoading: false)), (images) {
      emit(state.copyWith(images: images, isLoading: false, hasReachedMax: images.length < 20));
    });
  }

  Future<void> _onGetFact(GetFact event, Emitter<CatState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    final factResult = await getFact.call();
    factResult.fold((failure) => emit(state.copyWith(error: failure.message ?? 'Get fact failed', isLoading: false)), (fact) {
      emit(state.copyWith(fact: fact, isLoading: false));
    });
  }

  Future<void> _onRefreshImages(RefreshImages event, Emitter<CatState> emit) async {
    emit(state.copyWith(isLoading: true, error: null, images: [], currentPage: 0, hasReachedMax: false, searchQuery: null, breedIds: null));
    final imagesResult = await getImages.call(page: 0);
    imagesResult.fold((failure) => emit(state.copyWith(error: failure.message ?? 'Refresh failed', isLoading: false)), (images) {
      emit(state.copyWith(images: images, isLoading: false, hasReachedMax: images.length < 100));
    });
  }
}
