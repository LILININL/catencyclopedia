import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/favorite_cat.dart';
import '../../../domain/usecases/favorite/add_favorite.dart';
import '../../../domain/usecases/favorite/add_favorite_with_breed_data.dart';
import '../../../domain/usecases/favorite/remove_favorite.dart';
import '../../../domain/usecases/favorite/get_favorites.dart';
import '../../../domain/usecases/favorite/is_favorite.dart';
import '../../../domain/usecases/favorite/update_favorite.dart' as update_use_case;
import '../../../domain/usecases/favorite/clear_favorites.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final AddFavorite addFavorite;
  final AddFavoriteWithBreedData addFavoriteWithBreedData;
  final RemoveFavorite removeFavorite;
  final GetFavorites getFavorites;
  final IsFavorite isFavorite;
  final update_use_case.UpdateFavorite updateFavorite;
  final ClearFavorites clearFavorites;

  FavoriteBloc({
    required this.addFavorite,
    required this.addFavoriteWithBreedData,
    required this.removeFavorite,
    required this.getFavorites,
    required this.isFavorite,
    required this.updateFavorite,
    required this.clearFavorites,
  }) : super(const FavoriteState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<AddToFavoritesWithBreedData>(_onAddToFavoritesWithBreedData);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<CheckIsFavorite>(_onCheckIsFavorite);
    on<UpdateFavorite>(_onUpdateFavorite);
    on<ClearAllFavorites>(_onClearAllFavorites);
  }

  Future<void> _onLoadFavorites(LoadFavorites event, Emitter<FavoriteState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await getFavorites();
    result.fold((failure) => emit(state.copyWith(isLoading: false, error: failure.toString())), (favorites) {
      // อัพเดท favorite status cache
      final Map<String, bool> newStatus = Map.from(state.favoriteStatus);
      for (final fav in favorites) {
        newStatus[fav.id] = true;
      }

      emit(state.copyWith(isLoading: false, favorites: favorites, favoriteStatus: newStatus, error: null));
    });
  }

  Future<void> _onAddToFavorites(AddToFavorites event, Emitter<FavoriteState> emit) async {
    final result = await addFavorite(event.favoriteCat);
    result.fold((failure) => emit(state.copyWith(error: failure.toString())), (_) {
      // อัพเดท state
      final newFavorites = List<FavoriteCat>.from(state.favorites)..add(event.favoriteCat);
      final newState = state.copyWith(favorites: newFavorites);
      final updatedState = newState.updateFavoriteStatus(event.favoriteCat.id, true);
      emit(updatedState);
    });
  }

  Future<void> _onAddToFavoritesWithBreedData(AddToFavoritesWithBreedData event, Emitter<FavoriteState> emit) async {
    final params = AddFavoriteWithBreedDataParams(
      favoriteCat: event.favoriteCat,
      breedDescription: event.breedDescription,
      origin: event.origin,
      temperament: event.temperament,
      lifeSpan: event.lifeSpan,
      weight: event.weight,
      energyLevel: event.energyLevel,
      sheddingLevel: event.sheddingLevel,
      socialNeeds: event.socialNeeds,
      additionalData: event.additionalData,
    );

    final result = await addFavoriteWithBreedData(params);
    result.fold((failure) => emit(state.copyWith(error: failure.toString())), (_) {
      // สร้าง FavoriteCat entity ที่มีข้อมูลครบถ้วน
      final enrichedFavoriteCat = event.favoriteCat.copyWith(
        breedDescription: event.breedDescription,
        origin: event.origin,
        temperament: event.temperament,
        lifeSpan: event.lifeSpan,
        weight: event.weight,
        energyLevel: event.energyLevel,
        sheddingLevel: event.sheddingLevel,
        socialNeeds: event.socialNeeds,
        additionalData: event.additionalData,
        isFullyLoaded: true,
      );

      // อัพเดท state
      final newFavorites = List<FavoriteCat>.from(state.favorites)..add(enrichedFavoriteCat);
      final newState = state.copyWith(favorites: newFavorites);
      final updatedState = newState.updateFavoriteStatus(event.favoriteCat.id, true);
      emit(updatedState);
    });
  }

  Future<void> _onRemoveFromFavorites(RemoveFromFavorites event, Emitter<FavoriteState> emit) async {
    final result = await removeFavorite(event.catId);
    result.fold((failure) => emit(state.copyWith(error: failure.toString())), (_) {
      // อัพเดท state
      final newFavorites = state.favorites.where((fav) => fav.id != event.catId).toList();
      final newState = state.copyWith(favorites: newFavorites);
      final updatedState = newState.updateFavoriteStatus(event.catId, false);
      emit(updatedState);
    });
  }

  Future<void> _onCheckIsFavorite(CheckIsFavorite event, Emitter<FavoriteState> emit) async {
    final result = await isFavorite(event.catId);
    result.fold((failure) => emit(state.copyWith(error: failure.toString())), (isFav) {
      final updatedState = state.updateFavoriteStatus(event.catId, isFav);
      emit(updatedState);
    });
  }

  Future<void> _onUpdateFavorite(UpdateFavorite event, Emitter<FavoriteState> emit) async {
    final result = await updateFavorite(event.favoriteCat);
    result.fold((failure) => emit(state.copyWith(error: failure.toString())), (_) {
      // อัพเดท state
      final newFavorites = state.favorites.map((fav) {
        return fav.id == event.favoriteCat.id ? event.favoriteCat : fav;
      }).toList();
      emit(state.copyWith(favorites: newFavorites));
    });
  }

  Future<void> _onClearAllFavorites(ClearAllFavorites event, Emitter<FavoriteState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await clearFavorites();
    result.fold((failure) => emit(state.copyWith(isLoading: false, error: failure.toString())), (_) => emit(state.copyWith(isLoading: false, favorites: [], favoriteStatus: {}, error: null)));
  }
}
