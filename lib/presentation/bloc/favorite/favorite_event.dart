import 'package:equatable/equatable.dart';
import '../../../domain/entities/favorite_cat.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

/// โหลดรายการโปรดทั้งหมด
class LoadFavorites extends FavoriteEvent {}

/// เพิ่มแมวเข้ารายการโปรด
class AddToFavorites extends FavoriteEvent {
  final FavoriteCat favoriteCat;

  const AddToFavorites(this.favoriteCat);

  @override
  List<Object?> get props => [favoriteCat];
}

/// ลบแมวออกจากรายการโปรด
class RemoveFromFavorites extends FavoriteEvent {
  final String catId;

  const RemoveFromFavorites(this.catId);

  @override
  List<Object?> get props => [catId];
}

/// เช็คว่าแมวนี้เป็นโปรดไหม
class CheckIsFavorite extends FavoriteEvent {
  final String catId;

  const CheckIsFavorite(this.catId);

  @override
  List<Object?> get props => [catId];
}

/// ล้างรายการโปรดทั้งหมด
class ClearAllFavorites extends FavoriteEvent {}

/// อัพเดทข้อมูลโปรด
class UpdateFavorite extends FavoriteEvent {
  final FavoriteCat favoriteCat;

  const UpdateFavorite(this.favoriteCat);

  @override
  List<Object?> get props => [favoriteCat];
}
