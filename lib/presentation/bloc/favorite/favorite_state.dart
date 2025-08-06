import 'package:equatable/equatable.dart';
import '../../../domain/entities/favorite_cat.dart';

class FavoriteState extends Equatable {
  final List<FavoriteCat> favorites;
  final bool isLoading;
  final String? error;
  final Map<String, bool> favoriteStatus; // cache การเช็ค isFavorite

  const FavoriteState({
    this.favorites = const [],
    this.isLoading = false,
    this.error,
    this.favoriteStatus = const {},
  });

  FavoriteState copyWith({
    List<FavoriteCat>? favorites,
    bool? isLoading,
    String? error,
    Map<String, bool>? favoriteStatus,
  }) {
    return FavoriteState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      favoriteStatus: favoriteStatus ?? this.favoriteStatus,
    );
  }

  /// เช็คว่า catId นี้เป็นโปรดไหม
  bool isFavorite(String catId) {
    return favoriteStatus[catId] ?? false;
  }

  /// อัพเดท favorite status
  FavoriteState updateFavoriteStatus(String catId, bool isFavorite) {
    final newStatus = Map<String, bool>.from(favoriteStatus);
    newStatus[catId] = isFavorite;
    return copyWith(favoriteStatus: newStatus);
  }

  @override
  List<Object?> get props => [favorites, isLoading, error, favoriteStatus];
}
