import 'package:catencyclopedia/domain/entities/favorite_cat.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalCatDataSource {
  final Box favoriteCatsBox;

  LocalCatDataSource(this.favoriteCatsBox);

  Future<List<FavoriteCat>> getFavoriteCats() async {
    return favoriteCatsBox.values.cast<FavoriteCat>().toList();
  }

  Future<void> addFavoriteCat(FavoriteCat cat) async {
    await favoriteCatsBox.put(cat.id, cat);
  }

  Future<void> removeFavoriteCat(String catId) async {
    await favoriteCatsBox.delete(catId);
  }

  Future<bool> isCatFavorite(String catId) async {
    return favoriteCatsBox.containsKey(catId);
  }

  Future<void> clearFavorites() async {
    await favoriteCatsBox.clear();
  }

  Future<void> updateFavoriteCat(FavoriteCat cat) async {
    await favoriteCatsBox.put(cat.id, cat);
  }
}
